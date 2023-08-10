import shutil

path = "D:/project/subrecovery/miko/build/app/outputs/flutter-apk"

shutil.copy(f"{path}/app-release.apk", f"{path}/taptap.apk")
