#!/bin/bash

echo "=== Percy Wait and Approve Test Script ==="
echo "Setting up Percy token and BrowserStack credentials..."

# Check if environment variables are set, otherwise use defaults for local testing
if [ -z "$PERCY_TOKEN" ]; then
    echo "Warning: PERCY_TOKEN not set in environment, using local default"
    export PERCY_TOKEN=web_c9cb1c67cd7374b832464681299bbb07711525b7d35666fd7933e00736ff2db6
fi

if [ -z "$BROWSERSTACK_USERNAME" ]; then
    echo "Warning: BROWSERSTACK_USERNAME not set in environment, using local default"
    export BROWSERSTACK_USERNAME=tarunramiredddy_opM4Wv
fi

if [ -z "$BROWSERSTACK_ACCESS_KEY" ]; then
    echo "Warning: BROWSERSTACK_ACCESS_KEY not set in environment, using local default"
    export BROWSERSTACK_ACCESS_KEY=iAroSrEzrrykRF6sbmxA
fi

# Function to extract build ID from output
extract_build_id() {
    local output="$1"
    echo "$output" | grep -o 'builds/[0-9]*' | tail -1 | cut -d'/' -f2
}

# Function to wait for build completion
wait_for_build() {
    local build_id="$1"
    local test_name="$2"

    echo "[$test_name] Found build ID: $build_id"
    echo "[$test_name] Waiting for image processing to complete..."
    echo "[$test_name] This may take several minutes..."

    # Wait for build to complete with timeout of 10 minutes
    percy build:wait --build "$build_id" --timeout 600000 --interval 5000

    local wait_status=$?
    if [ $wait_status -eq 0 ]; then
        echo "[$test_name] Build processing completed at: $(date)"
        return 0
    else
        echo "[$test_name] Build wait failed or timed out"
        return 1
    fi
}

# Function to approve build
approve_build() {
    local build_id="$1"
    local test_name="$2"

    echo "[$test_name] Approving build ID: $build_id"
    npx percy build:approve "$build_id" --username "$BROWSERSTACK_USERNAME" --access-key "$BROWSERSTACK_ACCESS_KEY"

    local approve_status=$?
    if [ $approve_status -eq 0 ]; then
        echo "[$test_name] Build approved successfully at: $(date)"
        return 0
    else
        echo "[$test_name] Build approval failed"
        return 1
    fi
}

echo ""
echo "=========================================="
echo "PHASE 1: Running Test1"
echo "=========================================="
echo "Starting Percy build for Test1 at: $(date)"

# Run Test1 and capture output to extract build ID
TEST1_OUTPUT=$(percy exec --verbose -- mvn -q test -Dsurefire.suiteXmlFiles=src/test/resources/testng-test1.xml 2>&1)
echo "$TEST1_OUTPUT"

echo "Test1 Percy exec completed at: $(date)"

# Extract build ID from Test1 output
TEST1_BUILD_ID=$(extract_build_id "$TEST1_OUTPUT")

if [ -n "$TEST1_BUILD_ID" ]; then
    # Wait for Test1 build to complete
    if wait_for_build "$TEST1_BUILD_ID" "Test1"; then
        # Approve Test1 build
        if approve_build "$TEST1_BUILD_ID" "Test1"; then
            echo "[Test1] Build workflow completed successfully"
        else
            echo "[Test1] Warning: Build approval failed, but continuing..."
        fi
    else
        echo "[Test1] Warning: Build wait failed, skipping approval"
    fi
else
    echo "[Test1] Could not extract build ID from output"
    echo "[Test1] Please check the output above for the build URL"
fi

echo ""
echo "=========================================="
echo "PHASE 2: Running Test2"
echo "=========================================="
echo "Starting Percy build for Test2 at: $(date)"

# Run Test2 and capture output to extract build ID
TEST2_OUTPUT=$(percy exec --verbose -- mvn -q test -Dsurefire.suiteXmlFiles=src/test/resources/testng-test2.xml 2>&1)
echo "$TEST2_OUTPUT"

echo "Test2 Percy exec completed at: $(date)"

# Extract build ID from Test2 output
TEST2_BUILD_ID=$(extract_build_id "$TEST2_OUTPUT")

if [ -n "$TEST2_BUILD_ID" ]; then
    # Wait for Test2 build to complete
    if wait_for_build "$TEST2_BUILD_ID" "Test2"; then
        # Approve Test2 build
        if approve_build "$TEST2_BUILD_ID" "Test2"; then
            echo "[Test2] Build workflow completed successfully"
        else
            echo "[Test2] Warning: Build approval failed"
        fi
    else
        echo "[Test2] Warning: Build wait failed, skipping approval"
    fi
else
    echo "[Test2] Could not extract build ID from output"
    echo "[Test2] Please check the output above for the build URL"
fi

echo ""
echo "=========================================="
echo "SUMMARY"
echo "=========================================="
echo "Test1 Build ID: ${TEST1_BUILD_ID:-'Not found'}"
echo "Test2 Build ID: ${TEST2_BUILD_ID:-'Not found'}"
echo ""
echo "Script completed at: $(date)"
echo "=== All tests finished ==="