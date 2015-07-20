# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Setup resource requirements
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  config.vm.box = "ubuntu/trusty64"

  # This should match the version specified in your
  # Gemfile. You must have the omnibus vagrant plugin
  # installed for this to work.
  config.omnibus.chef_version = "12.3.0"

  # Enable if you want to use the Vagrant Berkshelf plugin to manage
  # Cookbooks.
  config.berkshelf.enabled = false

  # Assumes that the Vagrantfile is in the root of our
  # Chef repository.
  root_dir = File.dirname(File.expand_path(__FILE__))

  # Assumes that the node definitions are in the nodes
  # subfolder
  nodes = Dir[File.join(root_dir,'nodes','*.json')]

  # Iterate over each of the JSON files
  nodes.each do |file|
    node_json = JSON.parse(File.read(file))

    # Only process the node if it has a vagrant section
    if(node_json["vagrant"])
      vagrant_name = node_json["vagrant"]["name"]
      vagrant_ip = node_json["vagrant"]["ip"]

      # Allow us to remove certain items from the run_list if we're
      # using vagrant. Useful for things like networking configuration
      # which may not apply/ may break in the vagrant environment
      if exclusions = node_json["vagrant"]["exclusions"]
        exclusions.each do |exclusion|
          if node_json["run_list"].delete(exclusion)
            puts "removed #{exclusion} from the run list"
          end
        end
      end

      config.vm.define vagrant_name do |vagrant|
        vagrant.vm.hostname = vagrant_name

        # Only use private networking if we specified an
        # IP. Otherwise fallback to DHCP
        if vagrant_ip
          vagrant.vm.network :private_network, ip: vagrant_ip
        end

        vagrant.vm.provision "chef_solo" do |chef|

          # Use berks-cookbooks not cookbooks and remember
          # to explicitly vendor berkshelf cookbooks with
          # berks vendor if not using the berkshelf vagrant plugin
          chef.cookbooks_path = ["berks-cookbooks", "site-cookbooks"]
          chef.data_bags_path = "data_bags"
          chef.roles_path = "roles"

          # Instead of using add_recipe and add_role, just
          # assign the node definition json, this will take
          # care of populating the run_list.
          chef.json = node_json
        end
      end
    end
  end
end
