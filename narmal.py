import re
import shutil
import os
import glob
import json
import pyperclip


def modify_json(version: str, path: str):
    with open(path, "r") as f:
        data = json.load(f)
    data["version"] = version
    info = input("请输入更新信息：")
    data["info"] = info
    pyperclip.copy(info)
    with open(path, "w") as f:
        json.dump(data, f, indent=4)


def clearApk(path):
    apks = glob.glob(os.path.join(path, "*.apk"))
    for apk in apks:
        os.remove(apk)


clearApk("D:/project/subrecovery/blog/public/app/new")

version = ""
with open(r"D:/project/subrecovery/miko/pubspec.yaml", "r") as file:
    lines = file.readlines()
    version = lines[3]
version = re.sub(r"version:\s*", "", version)
version = re.sub(r"\n", "", version)
path = "D:/project/subrecovery/miko/build/app/outputs/flutter-apk"
newPath = "D:/project/subrecovery/blog/public/app/new"
modify_json(version, "D:/project/subrecovery/blog/public/app/new/upgrade.json")

shutil.copy(f"{path}/app-release.apk", f"{newPath}/app-release.apk")
shutil.copy(f"{path}/app-release.apk", f"{newPath}/app-release-{version}.apk")
