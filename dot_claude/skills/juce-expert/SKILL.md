---
name: juce-expert
description: Use when building JUCE 8 audio plugins or applications. Covers AudioProcessor lifecycle, APVTS, DSP module, CMake setup, real-time safety rules, and plugin format targets.
allowed-tools: Read, Grep, Glob, Bash, Edit, Task
---

# JUCE Expert (8.0.12)

## Core Mandates

- **CMake-first:** New projects use CMake + FetchContent. Projucer is legacy.
- **Real-time safety:** `processBlock` must never allocate, deallocate, lock a mutex, call `new`/`delete`, or block. These are hard invariants.
- **APVTS owns parameters:** All automatable parameters live in `AudioProcessorValueTreeState`. Never manage parameters manually.
- **Cache parameter pointers:** Look up `RangedAudioParameter*` once at construction — never look up by string ID in `processBlock`.
- **Buses API:** Use `isBusesLayoutSupported` for channel configuration. Never use the deprecated `JucePlugin_PreferredChannelConfigurations`.

## Project Setup (CMake)

```cmake
cmake_minimum_required(VERSION 3.22)
project(MyPlugin VERSION 0.1.0)

include(FetchContent)
FetchContent_Declare(juce
    GIT_REPOSITORY https://github.com/juce-framework/JUCE.git
    GIT_TAG        8.0.12)
FetchContent_MakeAvailable(juce)

juce_add_plugin(MyPlugin
    PLUGIN_MANUFACTURER_CODE Mfr1
    PLUGIN_CODE Mp01
    FORMATS VST3 AU Standalone
    PRODUCT_NAME "My Plugin")

target_sources(MyPlugin PRIVATE src/PluginProcessor.cpp src/PluginEditor.cpp)

target_compile_features(MyPlugin PRIVATE cxx_std_23)

target_link_libraries(MyPlugin
    PRIVATE
        juce::juce_audio_processors
        juce::juce_audio_utils
        juce::juce_dsp
    PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags
        juce::juce_recommended_warning_flags)
```

**Community starter:** [Pamplejuce](https://github.com/sudara/pamplejuce) — CMake + Catch2 + CI, the de facto template.

## AudioProcessor Lifecycle

```
Constructor → prepareToPlay → [processBlock]* → releaseResources → Destructor
```

| Method                                 | Thread | Purpose                                                              |
| :------------------------------------- | :----- | :------------------------------------------------------------------- |
| `prepareToPlay(sampleRate, blockSize)` | Main   | Allocate buffers, reset DSP state, prepare everything for processing |
| `processBlock(buffer, midiMessages)`   | Audio  | Real-time processing — NO allocation, NO locking, NO blocking        |
| `releaseResources()`                   | Main   | Free audio-thread resources                                          |
| `getStateInformation(MemoryBlock&)`    | Main   | Serialize state to DAW                                               |
| `setStateInformation(data, size)`      | Main   | Restore state from DAW                                               |

### processBlock Rules (Real-Time Safety)

- No `new`, `delete`, `malloc`, `free`
- No `std::vector::push_back` (may reallocate)
- No `std::mutex::lock` (may block)
- No file I/O, no network, no logging to disk
- No JUCE `ValueTree` or APVTS method calls that touch the message thread
- Use `juce::AbstractFifo` or lock-free queues (e.g., `moodycamel::ReaderWriterQueue`) for audio↔UI communication

## AudioProcessorValueTreeState (APVTS)

Always use the `ParameterLayout` constructor. Build layout in a static factory.

```cpp
// PluginProcessor.h
class MyProcessor : public juce::AudioProcessor {
public:
    using APVTS = juce::AudioProcessorValueTreeState;
    static APVTS::ParameterLayout createParameterLayout();

    APVTS apvts { *this, nullptr, "Parameters", createParameterLayout() };

private:
    // Cached raw pointers — safe to read on audio thread
    std::atomic<float>* gainParam  = nullptr;
    std::atomic<float>* cutoffParam = nullptr;
};

// PluginProcessor.cpp
APVTS::ParameterLayout MyProcessor::createParameterLayout() {
    std::vector<std::unique_ptr<juce::RangedAudioParameter>> params;
    params.push_back(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID{"gain", 1}, "Gain",
        juce::NormalisableRange<float>(0.0f, 1.0f), 0.5f));
    return { std::move(params) };
}

MyProcessor::MyProcessor() {
    gainParam  = apvts.getRawParameterValue("gain");
    cutoffParam = apvts.getRawParameterValue("cutoff");
}
```

**In processBlock:** read via `gainParam->load()` — atomic, real-time safe.

**In editor:** use attachment classes — never read APVTS on the audio thread from the UI.

```cpp
// PluginEditor.h
juce::AudioProcessorValueTreeState::SliderAttachment gainAttachment;

// PluginEditor.cpp — constructor
gainAttachment { audioProcessor.apvts, "gain", gainSlider }
```

## DSP Module

Configure via `ProcessSpec` in `prepareToPlay`, then call `process` in `processBlock`.

```cpp
void MyProcessor::prepareToPlay(double sampleRate, int blockSize) {
    juce::dsp::ProcessSpec spec;
    spec.sampleRate       = sampleRate;
    spec.maximumBlockSize = static_cast<uint32>(blockSize);
    spec.numChannels      = static_cast<uint32>(getTotalNumOutputChannels());

    processorChain.prepare(spec);
}

void MyProcessor::processBlock(juce::AudioBuffer<float>& buffer, juce::MidiBuffer&) {
    juce::dsp::AudioBlock<float> block(buffer);
    juce::dsp::ProcessContextReplacing<float> ctx(block);
    processorChain.process(ctx);
}

// Chain declaration (order = signal flow)
juce::dsp::ProcessorChain<
    juce::dsp::IIR::Filter<float>,
    juce::dsp::Gain<float>,
    juce::dsp::Reverb
> processorChain;
```

**Key DSP types:** `IIR::Filter`, `FIR::Filter`, `Gain`, `Oscillator`, `Convolution`, `Oversampling`, `Reverb`, `Chorus`, `Phaser`, `LadderFilter`, `WaveShaper`, `Compressor`.

## JUCE 8 Features

- **Direct2D renderer (Windows):** GPU-backed, hardware-accelerated. Enabled by default — no code change needed.
- **MIDI 2.0:** `juce::universal_midi_packets` namespace. `MidiMessage2` for UMP handling.
- **WebView UI:** `juce::WebBrowserComponent` with JavaScript bridge for web-based UIs.
- **Animation:** `juce::AnimatedPosition`, VBlank-synced via `juce::VBlankAttachment`.
- **Shaped text / Unicode:** `juce::ShapedText` for correct multilingual text layout.
- **AAX SDK bundled:** No separate SDK download for Pro Tools support.

## Plugin Formats

Declared in `juce_add_plugin` via `FORMATS`. Build outputs appear in `<build>/MyPlugin_artefacts/`.

| Format       | Target Use                        |
| :----------- | :-------------------------------- |
| `VST3`       | DAWs on Windows/Linux/macOS       |
| `AU`         | Logic, GarageBand (macOS only)    |
| `AUv3`       | iOS/macOS App Store               |
| `AAX`        | Pro Tools                         |
| `LV2`        | Linux DAWs (Ardour, Reaper/Linux) |
| `Standalone` | Standalone app for testing        |

Always develop against `Standalone` first — fastest iteration loop.

## ValueTree (Non-Parameter State)

Use for plugin state that isn't automatable (presets, UI state, non-parameter data).

```cpp
juce::ValueTree state { "MyPluginState" };
// Persist alongside APVTS:
void getStateInformation(juce::MemoryBlock& dest) {
    auto combined = juce::ValueTree("Root");
    combined.appendChild(apvts.copyState(), nullptr);
    combined.appendChild(state.createCopy(), nullptr);
    juce::MemoryOutputStream stream(dest, false);
    combined.writeToStream(stream);
}
```

**Thread safety:** ValueTree listeners fire on the message thread. Never read/write ValueTree from the audio thread.

## Interop with Zig / Mojo

Both interop through the C ABI — JUCE itself must remain in C++.

**Zig:** Write DSP algorithms in Zig, expose via `extern "C"` from a compiled static lib.

```zig
export fn process_filter(buf: [*]f32, len: usize, cutoff: f32) void { ... }
```

Link in CMake: `target_link_libraries(MyPlugin PRIVATE zig_filter_lib)`. Include the C header in the JUCE processor.

**Mojo:** Compile Mojo to a shared library exposing C functions via `@export`. Same pattern — link via CMake, call from C++ shim, never cross the boundary with C++ types.

**Invariant:** No C++ exceptions, STL types, or virtual dispatch may cross the C boundary into Zig or Mojo.

## Common Mistakes

| Mistake                                                 | Fix                                            |
| :------------------------------------------------------ | :--------------------------------------------- |
| Looking up parameter by ID in `processBlock`            | Cache `getRawParameterValue()` at construction |
| Calling `apvts.copyState()` on audio thread             | Only call on message thread                    |
| Using `JucePlugin_PreferredChannelConfigurations`       | Use `isBusesLayoutSupported`                   |
| `new`/`delete` in `processBlock`                        | Pre-allocate in `prepareToPlay`                |
| Inheriting from `Slider::Listener`                      | Use `SliderAttachment`                         |
| String ID lookups in hot path                           | Cache typed pointers at startup                |
| Not calling `processorChain.reset()` in `prepareToPlay` | Always reset DSP state before reuse            |
