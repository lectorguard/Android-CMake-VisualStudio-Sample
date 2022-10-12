git clean -fdX

mkdir bin
cd bin
cmake -G "Visual Studio 17 2022" -A ARM ^
	-DCMAKE_SYSTEM_NAME=Android ^
	-DCMAKE_SYSTEM_VERSION=24	^
	-DCMAKE_ANDROID_ARCH_ABI=armeabi-v7a  ^
	-DCMAKE_ANDROID_NDK=C:/Microsoft/AndroidNDK/android-ndk-r23c ^
	-DCMAKE_ANDROID_STL_TYPE=c++_static ^
	..
cd ..
@echo off
rem Command makes sure the build.gradle file uses the same SDK version as the cmake project. Not really necessary, we can just use the latest supported sdk version from Visual studio, because of backwards compatibility
rem powershell -Command "& { $file = 'AndroidPackaging\app\build.gradle.template'; $find = Get-Content $file | Select-String targetSdkVersion | Select-Object -ExpandProperty Line; $replace = '        targetSdkVersion %AndroidSDKVersion%';(Get-Content $file).replace($find, $replace) | Set-Content $file;}"
echo on

devenv bin\AndroidNativeActivity.sln ^
	/Command "File.AddExistingProject %cd%\AndroidPackaging\AndroidPackaging.androidproj" 