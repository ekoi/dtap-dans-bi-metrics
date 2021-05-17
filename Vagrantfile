# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

#
# Read pre-provisioned base box URLs, if available...
#
ddbim_base_box=File.read("ddbim_base_box").strip if File.file?("ddbim_base_box")
#
# ...and print if found.
#
($stderr.puts "Using ddbim base box: " + ddbim_base_box) if !ddbim_base_box.nil?

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    
    config.vm.define "ddbim", primary: true do |ddbim|
        if Vagrant.has_plugin?("vagrant-vbguest")
          config.vbguest.auto_update = false
        end
        if ddbim_base_box.nil?
            ddbim.vm.box = "bento/centos-8.3"
            ddbim.vm.box_version = "202012.21.0"
        else
            ddbim.vm.box = "pre-provisioned-" + ddbim_base_box
            ddbim.vm.box_url = ddbim_base_box
        end
        ddbim.vm.hostname = "dar"
        ddbim.vm.network :private_network, ip: "192.168.33.20"
    end

    
    config.vm.provision "ansible" do |ansible|
        ansible.extra_vars = {}
        ansible.playbook = "provisioning/sites.yml"
        ansible.config_file = "provisioning/ansible.cfg"
        ansible.inventory_path = "provisioning/hosts"
        ansible.galaxy_role_file = "provisioning/requirements.yml"
        ansible.ask_vault_pass = true if (!ENV["REUSE_CERT"].nil? && ENV["REUSE_CERT"] == "true")
        ansible.extra_vars["openssl_cert"] = { "self_signed" => true, "create_new" => false } if (!ENV["REUSE_CERT"].nil? && ENV["REUSE_CERT"] == "true")
        # Output as much as you can, or comment this out for silence
        #ansible.verbose = "vvvv"
        if ENV["EXTRAVARS"].nil?
            ansible.extra_vars["dans_yum_repos_enabled"] = ENV["YUM_REPOS_ENABLED"].split(",") if !ENV["YUM_REPOS_ENABLED"].nil?
            ansible.extra_vars["shared_dd_source_dir"] = ENV["DD_SOURCE_DIR"] if !ENV["DD_SOURCE_DIR"].nil?
        else
            ansible.extra_vars = ENV["EXTRAVARS"]
        end
    end

    #
    # Define VM parameters
    #
    config.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.memory = 3072
        vb.cpus = 2
        vb.customize ["guestproperty", "set", :id, "--timesync-threshold", "1000"]
        vb.customize ["guestproperty", "set", :id, "--timesync-interval", "1000"]
    end
end
