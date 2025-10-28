# Percy Selenium Project - Complete Analysis

## Project Overview
This is a Percy visual testing project using Selenium WebDriver with Java, TestNG, and Maven. The project performs visual regression testing on web pages using Percy's snapshot capabilities.

## Project Structure

```
demo/
├── pom.xml                                    # Maven configuration
├── test_percy_wait.sh                         # Enhanced automation script
├── src/
│   ├── main/
│   │   └── java/com/example/percy/
│   │       └── Main.java                      # Main application class
│   └── test/
│       ├── java/com/example/percy/
│       │   ├── Test1.java                     # Google homepage test
│       │   └── Test2.java                     # Facebook homepage test
│       └── resources/
│           ├── percy.properties               # Percy configuration
│           ├── testng.xml                     # Combined test suite
│           ├── testng-test1.xml              # Test1 only suite (NEW)
│           └── testng-test2.xml              # Test2 only suite (NEW)
└── target/                                    # Build output directory
```

## Dependencies (from pom.xml)

### Core Dependencies
1. **Selenium Java** (v4.32.0)
   - WebDriver automation framework
   - Browser automation capabilities

2. **WebDriverManager** (v6.3.2)
   - Automatic driver management for Chrome
   - Handles driver downloads and setup

3. **Percy Java Selenium** (v2.1.1)
   - Percy visual testing SDK
   - Snapshot capture and comparison

4. **TestNG** (v7.10.2)
   - Test framework for organizing and running tests
   - Provides annotations and assertions

### Build Plugins
- **Maven Surefire Plugin** (v3.2.5)
  - Test execution plugin
  - Configured with `useModulePath=false`

## Test Classes

### Test1.java
- **Purpose**: Tests Google homepage
- **Test Method**: `openGoogleHomePage()`
- **Actions**:
  1. Opens https://www.google.com
  2. Takes Percy snapshot named "Google Home Page"
  3. Validates page title is not empty
- **Browser Config**: Headless Chrome with security flags

### Test2.java
- **Purpose**: Tests Facebook homepage
- **Test Method**: `openFacebookHomePage()`
- **Actions**:
  1. Opens https://www.facebook.com
  2. Takes Percy snapshot named "Facebook Home Page"
  3. Validates page title is not empty
- **Browser Config**: Headless Chrome with security flags

### Common Setup (Both Tests)
```java
@BeforeMethod
- WebDriverManager.chromedriver().setup()
- ChromeOptions: --headless=new, --no-sandbox, --disable-dev-shm-usage
- Initialize ChromeDriver
- Initialize Percy instance

@AfterMethod
- Quit WebDriver
```

## TestNG Configuration Files

### testng.xml (Original - Combined)
- Suite Name: PercyVisualSuite
- Runs both Test1 and Test2 sequentially
- Parallel execution: disabled

### testng-test1.xml (NEW)
- Suite Name: PercyVisualSuite-Test1
- Runs only Test1
- Used for isolated Test1 execution

### testng-test2.xml (NEW)
- Suite Name: PercyVisualSuite-Test2
- Runs only Test2
- Used for isolated Test2 execution

## Enhanced Automation Script: test_percy_wait.sh

### Script Features

#### 1. **Environment Setup**
```bash
export PERCY_TOKEN=web_3b46e33edc1e59085cc5baa509b3e51b22c0ad6ff33552f16ff80bebedd71729
export BROWSERSTACK_USERNAME=tarunramiredddy_opM4Wv
export BROWSERSTACK_ACCESS_KEY=iAroSrEzrrykRF6sbmxA
```

#### 2. **Reusable Functions**

##### extract_build_id()
- Extracts Percy build ID from command output
- Uses grep and regex pattern matching
- Returns numeric build ID

##### wait_for_build()
- Parameters: build_id, test_name
- Waits for Percy build processing to complete
- Timeout: 10 minutes (600000ms)
- Polling interval: 10 seconds (10000ms)
- Returns status code (0=success, 1=failure)

##### approve_build()
- Parameters: build_id, test_name
- Automatically approves Percy build
- Uses `percy build:approve` command
- Returns status code (0=success, 1=failure)

#### 3. **Two-Phase Execution**

##### PHASE 1: Test1 Execution
1. Run Test1 using testng-test1.xml
2. Capture and display output
3. Extract Test1 build ID
4. Wait for Test1 build processing completion
5. Approve Test1 build if processing succeeds
6. Log all status messages with [Test1] prefix

##### PHASE 2: Test2 Execution
1. Run Test2 using testng-test2.xml
2. Capture and display output
3. Extract Test2 build ID
4. Wait for Test2 build processing completion
5. Approve Test2 build if processing succeeds
6. Log all status messages with [Test2] prefix

#### 4. **Summary Report**
- Displays both build IDs
- Shows completion timestamp
- Provides clear status for each phase

### Script Workflow Diagram

```
START
  ↓
Setup Environment Variables
  ↓
┌─────────────────────────────┐
│ PHASE 1: Test1              │
├─────────────────────────────┤
│ 1. Run Test1                │
│ 2. Extract Build ID         │
│ 3. Wait for Processing      │
│ 4. Approve Build            │
└─────────────────────────────┘
  ↓
┌─────────────────────────────┐
│ PHASE 2: Test2              │
├─────────────────────────────┤
│ 1. Run Test2                │
│ 2. Extract Build ID         │
│ 3. Wait for Processing      │
│ 4. Approve Build            │
└─────────────────────────────┘
  ↓
Display Summary
  ↓
END
```

## Percy CLI Commands Used

### 1. percy exec
```bash
percy exec --verbose -- mvn -q test -Dsurefire.suiteXmlFiles=<testng-file>
```
- Executes tests with Percy snapshot capture
- `--verbose`: Detailed output
- Runs Maven test with specific TestNG suite

### 2. percy build:wait
```bash
percy build:wait --build <build-id> --timeout 600000 --interval 10000
```
- Waits for build processing to complete
- `--build`: Specific build ID
- `--timeout`: Maximum wait time (10 minutes)
- `--interval`: Polling frequency (10 seconds)

### 3. percy build:approve
```bash
percy build:approve --build <build-id>
```
- Automatically approves a build
- Useful for CI/CD pipelines
- Marks snapshots as baseline

## Key Improvements in Enhanced Script

### 1. **Modular Design**
- Reusable functions for common operations
- Easier to maintain and extend
- Better error handling

### 2. **Separate Test Execution**
- Test1 and Test2 run independently
- Each has its own build ID
- Isolated approval workflow

### 3. **Automatic Build Approval**
- No manual intervention required
- Builds are approved after processing completes
- Suitable for automated pipelines

### 4. **Enhanced Logging**
- Clear phase separation
- Test-specific log prefixes
- Detailed status messages
- Summary report at the end

### 5. **Error Resilience**
- Continues execution even if one phase fails
- Graceful handling of missing build IDs
- Status code checking for all operations

## Usage Instructions

### Running the Enhanced Script

```bash
cd demo
chmod +x test_percy_wait.sh
./test_percy_wait.sh
```

### Expected Output

```
=== Percy Wait and Approve Test Script ===
Setting up Percy token and BrowserStack credentials...

==========================================
PHASE 1: Running Test1
==========================================
Starting Percy build for Test1 at: [timestamp]
[Test output...]
[Test1] Found build ID: 12345
[Test1] Waiting for image processing to complete...
[Test1] Build processing completed at: [timestamp]
[Test1] Approving build ID: 12345
[Test1] Build approved successfully at: [timestamp]
[Test1] Build workflow completed successfully

==========================================
PHASE 2: Running Test2
==========================================
Starting Percy build for Test2 at: [timestamp]
[Test output...]
[Test2] Found build ID: 12346
[Test2] Waiting for image processing to complete...
[Test2] Build processing completed at: [timestamp]
[Test2] Approving build ID: 12346
[Test2] Build approved successfully at: [timestamp]
[Test2] Build workflow completed successfully

==========================================
SUMMARY
==========================================
Test1 Build ID: 12345
Test2 Build ID: 12346

Script completed at: [timestamp]
=== All tests finished ===
```

## Configuration Files

### percy.properties
```properties
percy.token=web_3b46e33edc1e59085cc5baa509b3e51b22c0ad6ff33552f16ff80bebedd71729
```

## Browser Configuration

Both tests use Chrome with the following options:
- `--headless=new`: New headless mode
- `--no-sandbox`: Disable sandbox (for CI environments)
- `--disable-dev-shm-usage`: Overcome limited resource problems

## CI/CD Integration

This script is designed for CI/CD pipelines:
1. **Automated Execution**: No manual intervention needed
2. **Build Approval**: Automatic approval after processing
3. **Error Handling**: Continues even if one test fails
4. **Status Reporting**: Clear success/failure indicators
5. **Build Tracking**: Separate build IDs for each test

## Troubleshooting

### Build ID Not Found
- Check Percy token is valid
- Verify network connectivity
- Review test output for errors

### Build Wait Timeout
- Increase timeout value (default: 10 minutes)
- Check Percy service status
- Verify snapshot complexity

### Build Approval Failed
- Ensure Percy token has approval permissions
- Check build status in Percy dashboard
- Verify build ID is correct

## Next Steps

1. **Add More Tests**: Create Test3, Test4, etc.
2. **Parallel Execution**: Enable TestNG parallel mode
3. **Custom Snapshots**: Add more Percy snapshot options
4. **Reporting**: Integrate with reporting tools
5. **Notifications**: Add Slack/email notifications
6. **Conditional Approval**: Add logic for approval criteria

