cmake_minimum_required(VERSION 3.4.1)

project(AndroidNativeActivity)

cmake_path(SET ANDROID_NDK_PATH ${CMAKE_ANDROID_NDK})


# build native_app_glue as a static lib
set(${CMAKE_C_FLAGS}, "${CMAKE_C_FLAGS}")
add_library(native_app_glue STATIC ${ANDROID_NDK_PATH}/sources/android/native_app_glue/android_native_app_glue.c)

set(CMAKE_CXX_FLAGS -std=gnu++20)

# Export ANativeActivity_onCreate(),
# Refer to: https://github.com/android-ndk/ndk/issues/381.
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -u ANativeActivity_onCreate")

add_library(native-activity SHARED Source/main.cpp)

target_include_directories(native-activity PRIVATE ${ANDROID_NDK_PATH}/sources/android/native_app_glue)

# add lib dependencies
target_link_libraries(native-activity
    android
    native_app_glue
    EGL
    GLESv1_CM
    log)
