# устанавливаем основные инструменты (на всех узлах кластера)
sudo apt update
sudo apt install openjdk-17-jdk mc git -y

mkdir /opt/android-sdk

# wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
# unzip platform-tools-latest-linux.zip
# mv platform-tools /opt/android-sdk/platform-tools

# =========

wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip commandlinetools-linux-11076708_latest.zip
mv cmdline-tools /opt/android-sdk/cmdline-tools

tee -a ~/.bashrc <<EOF
export PATH=/opt/android-sdk/cmdline-tools/bin:\${PATH}
EOF

source ~/.bashrc

sdkmanager --licenses --sdk_root=/opt/android-sdk

# =========

wget https://services.gradle.org/distributions/gradle-8.7-bin.zip
unzip gradle-8.7-bin.zip
mv gradle-8.7 /opt/gradle

tee -a ~/.bashrc <<EOF
export ANDROID_HOME=/usr/lib/android-sdk
export PATH=\${ANDROID_HOME}/bin:\${PATH}

export GRADLE_HOME=/opt/gradle
export PATH=\${GRADLE_HOME}/bin:\${PATH}
EOF

source ~/.bashrc

# =========

wget https://dl.google.com/android/repository/android-ndk-r26d-linux.zip
unzip android-ndk-r26d-linux.zip
mv android-ndk-r26d /opt/android-ndk




sdkmanager --list --sdk_root=/opt/android-sdk

sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" --sdk_root=/opt/android-sdk
sdkmanager "tools" --sdk_root=/opt/android-sdk
sdkmanager --install "ndk;21.3.6528147" --channel=3 --sdk_root=/opt/android-sdk
sdkmanager --install "cmake;10.24988404" --sdk_root=/opt/android-sdk



cat ~/.bashrc

# =========
mkdir -p android
cd android

git clone https://github.com/kenx10/android-test-build.git
cd android-test-build/
gradle build
