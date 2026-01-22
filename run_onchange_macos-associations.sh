#!/bin/bash
# Set default handlers for text and data files to Zed
# This runs whenever this script changes

if command -v duti &> /dev/null; then
    echo "Setting macOS file associations for Zed..."
    
    # Bundle ID for Zed
    ZED_ID="dev.zed.Zed"

    # public.plain-text: covers .txt, .md, and other standard text files
    duti -s $ZED_ID public.plain-text all
    
    # public.data: covers extensionless files (config, Brewfile, Makefile, etc.)
    duti -s $ZED_ID public.data all
    
    # Common source files
    duti -s $ZED_ID .json all
    duti -s $ZED_ID .yaml all
    duti -s $ZED_ID .js all
    duti -s $ZED_ID .ts all
    duti -s $ZED_ID .rs all
else
    echo "duti not found, skipping associations"
fi
