## Cookbook Name:: deploy-drupal
## Recipe:: load_project
##
## load specified project (if any), and make sure
## project skeleton exists in deployment 

# assemble all necessary absolute paths
DEPLOY_PROJECT_DIR  = node['deploy-drupal']['deploy_dir']+ "/" +
                      node['deploy-drupal']['project_name']

DEPLOY_SITE_DIR     = DEPLOY_PROJECT_DIR + "/" +
                      node['deploy-drupal']['drupal_root_dir']

execute "get-project-from-git" do
  cwd node['deploy-drupal']['deploy_dir']
  command "git clone #{node['deploy-drupal']['get_project_from']['git']}"
  creates DEPLOY_PROJECT_DIR
  not_if {node['deploy-drupal']['get_project_from']['git'].empty? }
  notifies :restart, "service[apache2]", :delayed
end

execute "get-project-from-path" do
  command "cp -Rf '#{node['deploy-drupal']['get_project_from']['path']}/.'\
           '#{DEPLOY_PROJECT_DIR}'"
  creates DEPLOY_PROJECT_DIR
  not_if {node['deploy-drupal']['get_project_from']['empty'].empty? }
  notifies :restart, "service[apache2]", :delayed
end

directory DEPLOY_SITE_DIR do
  owner node['deploy-drupal']['apache_user']
  group node['deploy-drupal']['dev_group_name']
  recursive true
end
