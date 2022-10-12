# Android Cmake Visual Studio Sample Project

This is a small example android native-activity project using cmake and the gradle visual studio template project to create and debug android applications

## Features

* C++ 20 support
* Create Android native applications without any Java/Kotlin code using glue
* Use Cmake to generate Visual Studio project
* Visual Studio full debugging functionality for Release and Debug builds
* Fully configurable 
* Easy to set up
* No Android Studio

## Prerequisites

* Cmake 3.4.1 or higher
* Visual Studio 22 17.4 Preview 2 or higher
* Visual Studio Module : Mobile Development with C++
* Visual Studio Module : Desktop Development with C++
* devenv.exe must be set as environment variable (should be similar to C:\Program Files\Microsoft Visual Studio\2022\Preview\Common7\IDE)


## Installation Guide 

* Open GenerateProjectFiles.bat in a text editor of your choice 
* Make sure the cmake arguments fit your system 

```
	-DCMAKE_SYSTEM_NAME=Android 
	-DCMAKE_SYSTEM_VERSION=24 // Android SDK Version
	-DCMAKE_ANDROID_ARCH_ABI=armeabi-v7a // Architecture, you can change this setting within Visual Studio
	-DCMAKE_ANDROID_NDK=C:/Microsoft/AndroidNDK/android-ndk-r23c // Make sure this path is correct
								     // The ndk is installed by Visual Studio, you might need to update this path
	-DCMAKE_ANDROID_STL_TYPE=c++_static 
``` 
* Double check the path of the android ndk, maybe your visual studio installation uses another ndk
* Execute the GenerateProjectFiles.bat file
* After Visual Studio is open go to tools -> options and search for android. The paths in there should look like the following : Please update the paths in case it is wrong


```
Android SDK : C:\Program Files (x86)\Android\android-sdk
Android NDK : C:\Microsoft\AndroidNDK\android-ndk-r23c
Java SE Development Kit : C:\Program Files\Microsoft\jdk-11.0.12.7-hotspot
Apache Ant : 
```

* Now you can create and debug apks :) In case you want to debug on your device, you need to enable usb debugging and install the correct driver (see Setup USB Debugging section)

* In case debugging on your device is not working (unable to install apk), restart the ide by opening the **.sln** file in the **bin** folder 
* Double check if all configurations are working (Debug and Release), make sure to install the app on your device before switching the configuration

## Setup USB Debugging 

### Method 1:

- Download the compatible device USB driver (search online for device name + usb driver)
- Unzip the file to any location on your PC
- Double click on the .exe file
- Follow the instructions
- Click finish
- You can select now your usb connected device inside visual studio as target

### Method 2:

- Download the compatible device USB driver (search online for device name + usb driver)
- Unzip the file to any location on your PC
- Open the device manager and click on your computer
- On the top left click action -> add legacy hardware
- Select Install the hardware that I manually select from a list
- Select All devices
- Select Have Disk and set the path to your .inf file inside your extracted driver file
- Select Install the downloaded driver file
- Follow the remaining instructions and restart your pc
- You can select now your usb connected device inside visual studio as target

## Troubleshooting installation errors

```
The package manager failed to install the apk: '/data/local/tmp/NativeAndroidActivity.apk' with the error code: 'Unknown'
```

* In order to get more information install the apk via adb 
* You can browse to the adb.exe location or set the path as environment var
```
.\adb.exe install C:\TestAndroidBuild\AndroidPackaging\ARM\Debug\NativeAndroidActivity.apk
```

* In many cases uninstalling the app and rebuilding the visual studio project fixes the issue
* When switching configuaration, you always need to uninstall the old apk on your device


## Signing apks for realease builds

* In order to install a release build of an apk on a device, you need to sign the apk
* This project has an automated signing process via gradle with a keystore
* This is **not** production ready and should just be used for debugging release builds
* You find the password to the keystore inside AndroidPackaging/app/build.gradle under signingConfigs  

* [Create keystore](https://stackoverflow.com/questions/3997748/how-can-i-create-a-keystore)
* [Setup gradle to automatically sign apk](https://developer.android.com/studio/build/building-cmdline)

## Details about this project

This project is based on the C++ only native-activity sample project on [github](https://github.com/android/ndk-samples/tree/master/native-activity). Different to the sample project, we are using the [cmake android toolchain](https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html?highlight=toolchains#cross-compiling-for-android-with-the-ndk)
in combination with the [android gradle template project](https://devblogs.microsoft.com/cppblog/build-your-android-applications-in-visual-studio-using-gradle/) from visual studio. The idea behind the project is to create a shared library (.so) via the cmake project and to pack this library into the apk generated from the gradle template project from visual studio.
Inside the **GenerateProjectFiles.bat** the cmake project and the gradle visual studio project are combined into a single sln file. You can also do this manually by adding the existing project to the cmake generated solution file.
Inside the AndroidManifest.xml of the VS gradle project we are setting our generated shared library as main source. So when changing the name of cmake project, the name inside the AndroidManifest.xml must be updated. The gradle project must also reference the shared library project in visual studio. Make sure to update the reference when changing the shared library project name.
After modifying the default AndroidManifest.xml from the VS template project our file looks like this:

```
<application
	android:allowBackup="false"
	android:fullBackupContent="false"
	android:label="@string/app_name"
	android:hasCode="false"> // There is no java code, we will link directly with a shared lib (.so) and use glue as a layer between java and c++
	<activity android:name="android.app.NativeActivity" // We are using the android provided NativeActivity module
				android:label="@string/app_name"
				android:exported="true"
				android:configChanges="orientation|keyboardHidden"> // Keyboard is hidden by default
	<meta-data android:name="android.app.lib_name" 			    // thats the name of the shared library
					 android:value="native-activity" /> // This is the name of the generated .so file. The name must be correct otherwise the app wont start.
									    // You can use the everything tool to find the correct name of your .so file
      <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
      </intent-filter>
    </activity>
  </application>
```

Next to the packaging process, this project supports C++ 20 features. We can simply add that support by passing the correct compile flags from cmake to Visual Studio. But unfortunatly the settings are displayed not correctly inside Visual Studio properties.
Nevertheless, the settings are applied correctly inside Visual Studio. 

```
set(CMAKE_CXX_FLAGS -std=gnu++20)
```

## License

MIT License




