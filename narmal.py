import re
import shutil

version = ""

with open(r"D:/project/subrecovery/miko/pubspec.yaml", "r") as file:
    lines = file.readlines()
    version = lines[3]
version = re.sub(r"version:\s*", "", version)
version = re.sub(r"\n", "", version)
path = "D:/project/subrecovery/miko/build/app/outputs/flutter-apk"
newPath = "D:/project/subrecovery/blog/public/app/new"

shutil.copy(f"{path}/app-release.apk", f"{newPath}/app-release.apk")
shutil.copy(f"{path}/app-release.apk", f"{newPath}/app-release-{version}.apk")
shutil.copy(f"{path}/app-release.apk", f"{path}/异次元通讯-秋月版-{version}.apk")
