#!/usr/bin/python

import os
import json
import sys


current_dir = os.path.dirname(os.path.abspath(__file__))

GCS = 'gs://xxx/terraform/state/default.tfstate'

os.system('gsutil -q cp '+GCS+' '+current_dir+'/')

dictionary = {}
jsonout = {'_meta':{'hostvars':{}},'all':{'children':[]}}

with open(current_dir+'/default.tfstate') as terraformtf:
	dictionary = json.load(terraformtf)

for modules in dictionary['modules']:
	if modules.has_key('resources') and modules['resources']:
		for attributes in modules['resources']:
			if modules['resources'][attributes].has_key('type'):
				if modules['resources'][attributes]['type'] == 'google_compute_instance':
					instance_name = modules['resources'][attributes]['primary']['id']
					instance_ip = modules['resources'][attributes]['primary']['attributes']['network_interface.0.access_config.0.assigned_nat_ip']
					jsonout['_meta']['hostvars'][instance_name] = { 'ansible_host': instance_ip }
					group = attributes.replace('google_compute_instance.','')
					if 'app' in group:
						group='app'
					elif 'db' in group:
						group='db'
					else:
						group='ungrouped'
					if group not in jsonout['all']['children']:
						jsonout['all']['children'].append(group)
					if not jsonout.has_key(group):
						jsonout[group] = {'hosts':[]}
					jsonout[group]['hosts'].append(instance_name)

os.remove(current_dir+'/default.tfstate')

if '--list' in sys.argv:
	print json.dumps(jsonout,ensure_ascii=False)

