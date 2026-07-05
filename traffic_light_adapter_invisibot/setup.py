from glob import glob
import os

from setuptools import find_packages
from setuptools import setup

package_name = 'traffic_light_adapter_invisibot'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        (
            'share/ament_index/resource_index/packages',
            ['resource/' + package_name],
        ),
        ('share/' + package_name, ['package.xml']),
        (
            os.path.join('share', package_name, 'launch'),
            glob('launch/*.launch.xml'),
        ),
    ],
    install_requires=[
        'setuptools',
        'fastapi',
        'uvicorn',
        'pydantic',
        'requests>=2.25',
        'pyyaml',
        'nudged',
    ],
    zip_safe=True,
    maintainer='Gary Bey',
    maintainer_email='beyhy94@gmail.com',
    description='An RMF Traffic Light fleet adapter for invisibot',
    license='Apache License 2.0',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'fleet_adapter=traffic_light_adapter_invisibot.fleet_adapter:main',
        ],
    },
)
