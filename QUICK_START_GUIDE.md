# Quick Start Guide - Percy Test Automation

## Overview
This guide helps you quickly run the enhanced Percy test automation script that:
1. ✅ Runs Test1 (Google homepage)
2. ⏳ Waits for Test1 build processing
3. ✔️ Approves Test1 build automatically
4. ✅ Runs Test2 (Facebook homepage)
5. ⏳ Waits for Test2 build processing
6. ✔️ Approves Test2 build automatically

## Prerequisites

### Required Software
- ✅ Java 17 or higher
- ✅ Maven 3.6+
- ✅ Percy CLI installed (`npm install -g @percy/cli`)
- ✅ Chrome browser
- ✅ Bash shell

### Verify Installation
```bash
# Check Java
java -version

# Check Maven
mvn -version

# Check Percy CLI
percy --version

# Check Chrome
google-chrome --version  # Linux
# or
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version  # macOS
```

## Quick Start (3 Steps)

### Step 1: Navigate to Project Directory
```bash
cd /Users/ramirety/Desktop/percy_sele/demo
```

### Step 2: Make Script Executable
```bash
chmod +x test_percy_wait.sh
```

### Step 3: Run the Script
```bash
./test_percy_wait.sh
```

That's it! The script will handle everything automatically.

## What Happens When You Run the Script

### Phase 1: Test1 Execution
```
==========================================
PHASE 1: Running Test1
==========================================
```
1. **Runs Test1**: Opens Google homepage in headless Chrome
2. **Takes Snapshot**: Captures visual snapshot with Percy
3. **Extracts Build ID**: Automatically finds the Percy build ID
4. **Waits for Processing**: Polls Percy until images are processed (max 10 min)
5. **Approves Build**: Automatically approves the build

### Phase 2: Test2 Execution
```
==========================================
PHASE 2: Running Test2
==========================================
```
1. **Runs Test2**: Opens Facebook homepage in headless Chrome
2. **Takes Snapshot**: Captures visual snapshot with Percy
3. **Extracts Build ID**: Automatically finds the Percy build ID
4. **Waits for Processing**: Polls Percy until images are processed (max 10 min)
5. **Approves Build**: Automatically approves the build

### Summary Report
```
==========================================
SUMMARY
==========================================
Test1 Build ID: 12345
Test2 Build ID: 12346

Script completed at: [timestamp]
=== All tests finished ===
```

## Understanding the Output

### Successful Execution Example
```bash
=== Percy Wait and Approve Test Script ===
Setting up Percy token and BrowserStack credentials...

==========================================
PHASE 1: Running Test1
==========================================
Starting Percy build for Test1 at: Tue Oct 28 15:30:00 EDT 2025

[Percy] Percy has started!
[Percy] Created build #12345: https://percy.io/org/project/builds/12345
[INFO] Running tests...
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0

Test1 Percy exec completed at: Tue Oct 28 15:30:15 EDT 2025
[Test1] Found build ID: 12345
[Test1] Waiting for image processing to complete...
[Test1] This may take several minutes...
[Percy] Build #12345 is now processing...
[Percy] Build #12345 finished! (2 snapshots)
[Test1] Build processing completed at: Tue Oct 28 15:31:00 EDT 2025
[Test1] Approving build ID: 12345
[Percy] Build #12345 approved successfully
[Test1] Build approved successfully at: Tue Oct 28 15:31:05 EDT 2025
[Test1] Build workflow completed successfully

==========================================
PHASE 2: Running Test2
==========================================
Starting Percy build for Test2 at: Tue Oct 28 15:31:10 EDT 2025

[Percy] Percy has started!
[Percy] Created build #12346: https://percy.io/org/project/builds/12346
[INFO] Running tests...
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0

Test2 Percy exec completed at: Tue Oct 28 15:31:25 EDT 2025
[Test2] Found build ID: 12346
[Test2] Waiting for image processing to complete...
[Test2] This may take several minutes...
[Percy] Build #12346 is now processing...
[Percy] Build #12346 finished! (2 snapshots)
[Test2] Build processing completed at: Tue Oct 28 15:32:10 EDT 2025
[Test2] Approving build ID: 12346
[Percy] Build #12346 approved successfully
[Test2] Build approved successfully at: Tue Oct 28 15:32:15 EDT 2025
[Test2] Build workflow completed successfully

==========================================
SUMMARY
==========================================
Test1 Build ID: 12345
Test2 Build ID: 12346

Script completed at: Tue Oct 28 15:32:15 EDT 2025
=== All tests finished ===
```

## Key Features

### 🔄 Automatic Build Approval
- No manual intervention needed
- Builds are approved after processing completes
- Perfect for CI/CD pipelines

### ⏱️ Smart Waiting
- Waits up to 10 minutes for build processing
- Polls every 10 seconds
- Continues to next phase even if one fails

### 📊 Clear Status Reporting
- Each test has its own labeled output `[Test1]` or `[Test2]`
- Summary shows both build IDs
- Timestamps for all major events

### 🛡️ Error Resilience
- Continues execution even if one test fails
- Graceful handling of missing build IDs
- Clear error messages

## Customization Options

### Change Timeout Duration
Edit line 25 in `test_percy_wait.sh`:
```bash
# Current: 10 minutes (600000ms)
percy build:wait --build "$build_id" --timeout 600000 --interval 10000

# Change to 15 minutes:
percy build:wait --build "$build_id" --timeout 900000 --interval 10000
```

### Change Polling Interval
Edit line 25 in `test_percy_wait.sh`:
```bash
# Current: 10 seconds (10000ms)
percy build:wait --build "$build_id" --timeout 600000 --interval 10000

# Change to 5 seconds:
percy build:wait --build "$build_id" --timeout 600000 --interval 5000
```

### Run Only Test1
```bash
percy exec --verbose -- mvn test -Dsurefire.suiteXmlFiles=src/test/resources/testng-test1.xml
```

### Run Only Test2
```bash
percy exec --verbose -- mvn test -Dsurefire.suiteXmlFiles=src/test/resources/testng-test2.xml
```

### Run Both Tests Together (Original)
```bash
percy exec --verbose -- mvn test -Dsurefire.suiteXmlFiles=src/test/resources/testng.xml
```

## Troubleshooting

### Problem: "percy: command not found"
**Solution**: Install Percy CLI
```bash
npm install -g @percy/cli
```

### Problem: "Build ID not found"
**Possible Causes**:
- Percy token is invalid
- Network connectivity issues
- Test execution failed

**Solution**: Check the test output for errors and verify Percy token

### Problem: "Build wait timeout"
**Possible Causes**:
- Percy service is slow
- Complex snapshots taking longer
- Network issues

**Solution**: Increase timeout value or check Percy dashboard

### Problem: "Build approval failed"
**Possible Causes**:
- Percy token lacks approval permissions
- Build is already approved
- Build is in error state

**Solution**: Check Percy dashboard and verify token permissions

### Problem: Chrome driver issues
**Solution**: WebDriverManager should handle this automatically, but if issues persist:
```bash
# Clear WebDriver cache
rm -rf ~/.cache/selenium/
```

## File Locations

### Test Configuration Files
- `src/test/resources/testng-test1.xml` - Test1 suite configuration
- `src/test/resources/testng-test2.xml` - Test2 suite configuration
- `src/test/resources/testng.xml` - Combined suite configuration

### Test Source Files
- `src/test/java/com/example/percy/Test1.java` - Google homepage test
- `src/test/java/com/example/percy/Test2.java` - Facebook homepage test

### Configuration
- `src/test/resources/percy.properties` - Percy token configuration
- `pom.xml` - Maven dependencies and build configuration

### Automation Script
- `test_percy_wait.sh` - Main automation script

## Environment Variables

The script uses these environment variables:

```bash
PERCY_TOKEN=web_3b46e33edc1e59085cc5baa509b3e51b22c0ad6ff33552f16ff80bebedd71729
BROWSERSTACK_USERNAME=tarunramiredddy_opM4Wv
BROWSERSTACK_ACCESS_KEY=iAroSrEzrrykRF6sbmxA
```

**Note**: These are set automatically by the script. You don't need to export them manually.

## Viewing Results

### Percy Dashboard
After the script completes, view your builds at:
- Test1: `https://percy.io/[your-org]/[your-project]/builds/[Test1-Build-ID]`
- Test2: `https://percy.io/[your-org]/[your-project]/builds/[Test2-Build-ID]`

### Local Test Reports
Maven Surefire generates HTML reports at:
```
demo/target/surefire-reports/index.html
```

Open in browser:
```bash
open demo/target/surefire-reports/index.html  # macOS
xdg-open demo/target/surefire-reports/index.html  # Linux
```

## CI/CD Integration

### GitHub Actions Example
```yaml
name: Percy Visual Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Java
        uses: actions/setup-java@v2
        with:
          java-version: '17'
          
      - name: Install Percy CLI
        run: npm install -g @percy/cli
        
      - name: Run Percy Tests
        env:
          PERCY_TOKEN: ${{ secrets.PERCY_TOKEN }}
        run: |
          cd demo
          chmod +x test_percy_wait.sh
          ./test_percy_wait.sh
```

### Jenkins Pipeline Example
```groovy
pipeline {
    agent any
    
    environment {
        PERCY_TOKEN = credentials('percy-token')
    }
    
    stages {
        stage('Setup') {
            steps {
                sh 'npm install -g @percy/cli'
            }
        }
        
        stage('Run Percy Tests') {
            steps {
                dir('demo') {
                    sh 'chmod +x test_percy_wait.sh'
                    sh './test_percy_wait.sh'
                }
            }
        }
    }
}
```

## Next Steps

1. **Review Percy Dashboard**: Check visual snapshots and comparisons
2. **Add More Tests**: Create Test3, Test4, etc. following the same pattern
3. **Customize Snapshots**: Add Percy snapshot options (widths, min-height, etc.)
4. **Integrate with CI/CD**: Add to your pipeline
5. **Set Up Notifications**: Configure alerts for visual changes

## Support

For issues or questions:
- Percy Documentation: https://docs.percy.io/
- Selenium Documentation: https://www.selenium.dev/documentation/
- TestNG Documentation: https://testng.org/doc/documentation-main.html

## Summary

This enhanced script provides a complete automated workflow for:
- ✅ Running visual tests
- ⏳ Waiting for build processing
- ✔️ Automatically approving builds
- 📊 Generating comprehensive reports

Perfect for CI/CD pipelines and automated visual regression testing!

