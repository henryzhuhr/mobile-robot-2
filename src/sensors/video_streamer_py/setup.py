from setuptools import setup

package_name = "video_streamer_py"

setup(
    name=package_name,
    version="0.0.0",
    packages=[package_name],
    data_files=[
        ("share/ament_index/resource_index/packages", ["resource/" + package_name]),
        ("share/" + package_name, ["package.xml"]),
    ],
    install_requires=["setuptools"],
    zip_safe=True,
    tests_require=["pytest"],
    entry_points={
        "console_scripts": [
            "video_reader = video_streamer_py.video_reader:main",
            "video_viewer = video_streamer_py.video_viewer:main",
        ],
    },
)
