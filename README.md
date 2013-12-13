# vagrant-phalcon

a template for using Vagrant for developing PHP applications with Phalcon

## Getting Started

1. Download and install [VirtualBox](https://www.virtualbox.org/)
2. Download and install [Vagrant](http://www.vagrantup.com/)
3. Clone this repo
4. Run `vagrant up` in the repo directory
5. Visit `http://localhost:8081/` in your favorite browser

### Note

Nginx is configured by default to use `./src/Public/` as the root directory. 
If your public directory differs, be sure to update the [`base.pp`](provision/puppet/manifests/base.pp) file to 
reflect your needs.

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/ee449352f9866118390e46bde6e6750a "githalytics.com")](http://githalytics.com/slogsdon/vagrant-phalcon)
