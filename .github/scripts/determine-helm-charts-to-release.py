#!/usr/bin/env python

import os, json;

parent_charts_dir=os.environ['CHARTS_DIR']

helm_charts=[]
for file in os.listdir(parent_charts_dir):
    if os.path.isdir(os.path.join(parent_charts_dir, file)):
        helm_charts.append(file)

print(f"::set-output name=helm-charts::{helm_charts}")
