# Description

The __wlp__ cookbook installs and configures the WebSphere Application Server Liberty Profile.
It provides recipes, resources, and libraries for creating, managing, and configuring Liberty profile server instances.

## Basic configuration

The __wlp__ cookbook can install the Liberty profile from jar archive files or a zip file. The installation method is configured via the `node[:wlp][:install_method]` attribute.

### jar installation

The `node[:wlp][:archive][:version_yaml]` attribute provides the location of a Yaml file which lists the URLs of the jar archive file for the latest release and latest beta. By default the latest release is installed. To install the latest beta, set the `node[:wlp][:archive][:use_beta]` attribute to `true`.

The `node[:wlp][:archive][:runtime][:url]` attribute, when set, overrides the location from the Yaml file. Setting it also causes the `node[:wlp][:archive][:extended][:url]` and `node[:wlp][:archive][:extras][:url]` to be used.

For more information on these options, see the attributes section later in this readme. You must also set the `node[:wlp][:archive][:accept_license]` attribute to `true` if you agree and accept the license terms of the Liberty profile software. The jar installation fails if `node[:wlp][:archive][:accept_license]` is not set to `true`.

By default the cookbook is configured to use the jar installation method. The archive options are already configured with values based on developer licensed Liberty profile.

The no-fee developer licensed Liberty profile jar archive files can be downloaded from [Liberty download page](https://www.ibmdw.net/wasdev/downloads/websphere-application-server-liberty-profile/) on [WASdev](https://www.ibmdw.net/wasdev) site. The production licensed Liberty profile jar archive files can be obtained from [IBM Passport Advantage](http://www-01.ibm.com/software/lotus/passportadvantage/).

### zip installation

When the zip installation method is used, only the `node[:wlp][:zip][:url]` attribute must be set to specify the location of the zip file. The zip file is assumed to be generated by running the `./bin/server package` Liberty command with the  `--include=all` or `--include=minify` option.



# Requirements

## Platform:

* aix
* debian
* ubuntu
* centos
* redhat

## Cookbooks:

* java (>= 1.16.4)

# Attributes

* `node[:wlp][:user]` - User name under which the server is installed and runs. Defaults to `wlp`.
* `node[:wlp][:group]` - Group name under which the server is installed and runs. Defaults to `wlpadmin`.
* `node[:wlp][:install_java]` - Use the `java` cookbook to install Java. If Java is installed using a
different method override it to `false`, in which case, the Java executables
must be available on the __PATH__. Defaults to `true`.
* `node[:wlp][:base_dir]` - Base installation directory. Defaults to `/opt/was/liberty`.
* `node[:wlp][:user_dir]` - User directory (wlp.user.dir). Set to 'nil' to use default location. Defaults to `nil`.
* `node[:wlp][:install_method]` - Installation method. Set it to 'archive' or 'zip'. Defaults to `archive`.
* `node[:wlp][:archive][:version_yaml]` - Location of the Yaml file containing the URLs of the 'archive' install file
 for the latest release and latest beta. Defaults to `http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/index.yml`.
* `node[:wlp][:archive][:use_beta]` - Use the beta instead of the release. Defaults to `false`.
* `node[:wlp][:archive][:runtime][:url]` - URL location of the runtime archive. Overrides the location in the Yaml file. Defaults to `nil`.
* `node[:wlp][:archive][:extended][:url]` - URL location of the extended archive. Only used if the archive runtime url
 is set. Defaults to `nil`.
* `node[:wlp][:archive][:extras][:url]` - URL location of the extras archive. Only used if
 `node[:wlp][:archive][:runtime][:url]` is set. Defaults to `nil`.
* `node[:wlp][:archive][:extended][:install]` - Controls whether the extended archive is downloaded and installed. Defaults to `true`.
* `node[:wlp][:archive][:extras][:install]` - Controls whether the extras archive is downloaded and installed. Defaults to `false`.
* `node[:wlp][:archive][:extras][:base_dir]` - Base installation directory of the extras archive. Defaults to `#{node[:wlp][:base_dir]}/extras`.
* `node[:wlp][:archive][:accept_license]` - Accept license terms when doing archive-based installation.
 Must be set to `true` or the installation fails. Defaults to `false`.
* `node[:wlp][:zip][:url]` - URL location for a zip file containing Liberty profile installation files.
 Must be set if `node[:wlp][:install_method]` is set to `zip`. Defaults to `nil`.
* `node[:wlp][:repository][:liberty]` - Controls whether installUtility uses the online liberty repository. Defaults to `true`.
* `node[:wlp][:repository][:hosted_url]` - Sets the URL of the hosted asset repostiory used by installUtility. Defaults to `nil`.
* `node[:wlp][:repository][:local_url]` - Sets the path or URL of a directory based asset repository used by installUtility. Defaults to `nil`.
* `node[:wlp][:config][:basic]` - Defines a basic server configuration when creating server instances using
 the `wlp_server` resource. Defaults to `{ ... }`.
* `node[:wlp][:servers][:defaultServer]` - Defines a `defaultServer` server instance. Used by the `serverconfig` recipe. Defaults to `{ ... }`.

# Recipes

* [wlp::default](#wlpdefault) - Installs WebSphere Application Server Liberty Profile.
* [wlp::repositories_properties](#wlprepositories_properties)
* [wlp::serverconfig](#wlpserverconfig) - Creates a Liberty profile server instance for each `node[:wlp][:servers][<server_name>]` definition.

## wlp::default

Installs WebSphere Application Server Liberty Profile. Liberty profile can be
installed using jar archive files, or from a zip file based on the `node[:wlp][:install_method]` setting.

## wlp::repositories_properties

Creates the file etc/repositories.properties in the wlp dir to configure which repositories are used by installUtility

## wlp::serverconfig

Creates a Liberty profile server instance for each `node[:wlp][:servers][<server_name>]` definition.
The following definition creates a simple `airport` server instance:
```ruby
node[:wlp][:servers][:airport] = {
  "enabled" => true,
  "description" => "Airport Demo App",
  "featureManager" => {
    "feature" => [ "jsp-2.2" ]
  },
  "httpEndpoint" => {
    "id" => "defaultHttpEndpoint",
    "host" => "*",
    "httpPort" => "9080",
    "httpsPort" => "9443"
  }
}
```

# Resources

* [wlp_bootstrap_properties](#wlp_bootstrap_properties) - Adds, removes, and sets bootstrap properties for a particular server instance.
* [wlp_collective](#wlp_collective) - Provides operations for creating, joining, replicating, and removing Liberty profile servers from a collective.
* [wlp_config](#wlp_config) - Generates a server.xml file from a hash expression.
* [wlp_download_feature](#wlp_download_feature) - Downloads an asset from the Liberty Repository or a local LARS reposiory using installUtility.
* [wlp_install_feature](#wlp_install_feature) - Installs or downloads an asset from the Liberty Repository, a local LARS reposiory, or a local directory based repository using installUtility.
* [wlp_jvm_options](#wlp_jvm_options) - Adds, removes, and sets JVM options in an installation-wide or instance-specific jvm.options file.
* [wlp_server](#wlp_server) - Provides operations for creating, starting, stopping, and destroying Liberty profile server instances.
* [wlp_server_env](#wlp_server_env) - Adds, removes, and sets environment properties in installation-wide or instance-specific server.env file.

## wlp_bootstrap_properties

Adds, removes, and sets bootstrap properties for a particular server instance.

### Actions

- set: Set properties in the bootstrap.properties file. Other existing properties in the file are not preserved. Default action.
- add: Adds properties to the bootstrap.properties file. Other existing properties in the file are preserved.
- remove: Removes properties from the bootstrap.properties file. Other existing properties in the file are preserved.

### Attribute Parameters

- server_name: Name of the server instance. Defaults to <code>nil</code>.
- properties: The properties to add, remove, or set. Must be specified as a hash when adding or setting and as an array when removing. Defaults to <code>nil</code>.

### Examples
```ruby
wlp_bootstrap_properties "add to bootstrap.properties" do
  server_name "myInstance"
  properties "com.ibm.ws.logging.trace.file.name" => "trace.log"
  action :add
end

wlp_bootstrap_properties "remove from bootstrap.properties" do
  server_name "myInstance"
  properties [ "com.ibm.ws.logging.trace.file.name" ]
  action :remove
end

wlp_bootstrap_properties "set bootstrap.properties" do
  properties "default.http.port" => "9081", "default.https.port" => "9444"
  action :set
end
```

## wlp_collective

Provides operations for creating, joining, replicating, and removing Liberty profile servers from a collective.

### Actions

- create: Creates the initial collective controller for the Liberty collective. Default action.
- join: Joins a Liberty server to the collective managed by the specified collective controller.
- remove: Creates and starts the server instance (as an OS service).
- replicate: Destroys the server instance.

### Attribute Parameters

- server_name: Name of the server instance to operate on
- keystorePassword: The keystore password to set when creating the collective SSL configuration. Defaults to <code>nil</code>.
- host: The host of the collective controller to join to, replicate from or remove from. If not specified, the controller host will be looked up from the Chef server. Defaults to <code>nil</code>.
- port: The port of the collective controller to join to, replicate from or remove from. If not specified, the controller port will be looked up from the Chef server. Defaults to <code>nil</code>.
- user: An Administrative user name. The join, replicate and remove actions require an authenticated user. Defaults to <code>nil</code>.
- password: The Administrative user's password. The join, replicate and remove actions require an authenticated user. Defaults to <code>nil</code>.
- admin_user: Name of the quickStartSecurity admin userid Defaults to <code>nil</code>.
- admin_password: Name of the quickStartSecurity admin password Defaults to <code>nil</code>.

### Examples
```ruby
Fill me in!
```

## wlp_config

Generates a server.xml file from a hash expression.

### Actions

- create: Creates or updates the server.xml file. Default action.
- create_if_missing: Creates a server.xml file only if the file does not already exist.

### Attribute Parameters

- file: The server.xml file to create or update. Defaults to <code>nil</code>.
- config: The contents of the server.xml file expressed as a hash. Defaults to <code>nil</code>.

### Examples
```ruby
wlp_config "/var/servers/airport/server.xml" do
  config ({
            "description" => "Airport Demo App",
            "featureManager" => {
              "feature" => [ "jsp-2.2" ]
            },
            "httpEndpoint" => {
              "id" => "defaultHttpEndpoint",
              "host" => "*",
              "httpPort" => "9080",
              "httpsPort" => "9443"
            }
  })
end
```

## wlp_download_feature

Downloads an asset from the Liberty Repository or a local LARS reposiory using installUtility.

### Actions

- download: Downloads an asset from the configured repository to the specified directory. Default action.

### Attribute Parameters

- name: Specifies the name of the asset to be downloaded. Defaults to <code>nil</code>.
- directory: Specifies which local directory path utilities are downloaded to when using the :download action. Defaults to <code>nil</code>.
- accept_license: Specifies whether to accept the license terms and conditions of the feature. Defaults to <code>false</code>.

### Examples
```ruby
wlp_install_utility "mongodb" do
  name "mongodb-2.0"
  directory "/opt/ibm/wlp/features"
  accept_license true
end
```

## wlp_install_feature

Installs or downloads an asset from the Liberty Repository, a local LARS reposiory, or a local directory based repository using installUtility.

### Actions

- install: Installs an asset from which ever repositoryis confiugured in the repositoies.properties file. Default action.

### Attribute Parameters

- name: Specifies the name of the asset to be installed. Defaults to <code>nil</code>.
- to: Specifies where to install the feature. The feature can be installed to any configured product extension location, or as a user feature. Defaults to <code>"usr"</code>.
- accept_license: Specifies whether to accept the license terms and conditions of the feature. Defaults to <code>false</code>.

### Examples
```ruby
wlp_install_utility "mongodb" do
  name "mongodb-2.0"
  accept_license true
end
```

## wlp_jvm_options

Adds, removes, and sets JVM options in an installation-wide or instance-specific jvm.options file.

### Actions

- add: Adds JVM options to a jvm.options file. Other existing options in the file are preserved. Default action.
- remove: Removes JVM options from a jvm.options file. Other existing options in the file are preserved.
- set: Sets JVM options in a jvm.options file. Other existing options are not preserved.

### Attribute Parameters

- server_name: If specified, the jvm.options file in the specified server instance is updated. Otherwise, the installation-wide jvm.options file is updated. Defaults to <code>nil</code>.
- options: The JVM options to add, set, or remove. Defaults to <code>nil</code>.

### Examples
```ruby
wlp_jvm_options "add to instance-specific jvm.options" do
  server_name "myInstance"
  options [ "-Djava.net.ipv4=true" ]
  action :add
end

wlp_jvm_options "remove from instance-specific jvm.options" do
  server_name "myInstance"
  options [ "-Djava.net.ipv4=true" ]
  action :remove
end

wlp_jvm_options "add to installation-wide jvm.options" do
  options [ "-Xmx1024m" ]
  action :add
end

wlp_jvm_options "remove from installation-wide jvm.options" do
  options [ "-Xmx1024m" ]
  action :remove
end
```

## wlp_server

Provides operations for creating, starting, stopping, and destroying Liberty profile server instances.

### Actions

- start: Creates and starts the server instance (as an OS service). Default action.
- create: Creates or updates the server instance.
- create_if_missing: Creates a server instance only if the instance does not already exist.
- destroy: Destroys the server instance.
- stop: Stops the server instance (via an OS service).

### Attribute Parameters

- server_name: Name of the server instance.
- config: Configuration for the server instance. If not specified, `node[:wlp][:config][:basic]` is used as the initial configuration. Defaults to <code>nil</code>.
- jvmOptions: Instance-specific JVM options. Defaults to <code>[]</code>.
- serverEnv: Instance-specific server environment properties. Defaults to <code>{}</code>.
- bootstrapProperties: Instance-specific bootstrap properties. Defaults to <code>{}</code>.
- clean: Clean all cached information when starting the server instance. Defaults to <code>false</code>.
- skip_umask: Skip setting umask and use user default. Defaults to <code>false</code>.

### Examples
```ruby
wlp_server "myInstance" do
  config ({
            "featureManager" => {
              "feature" => [ "jsp-2.2", "jaxws-2.1" ]
            },
            "httpEndpoint" => {
              "id" => "defaultHttpEndpoint",
              "host" => "*",
              "httpPort" => "9080",
              "httpsPort" => "9443"
            },
            "application" => {
              "id" => "example",
              "name" => "example",
              "type" => "war",
              "location" => "/apps/example.war"
            }
          })
  jvmOptions [ "-Djava.net.ipv4=true" ]
  serverEnv "JAVA_HOME" => "/usr/lib/j2sdk1.7-ibm/"
  bootstrapProperties "default.http.port" => "9080", "default.https.port" => "9443"
  action :create
end

wlp_server "myInstance" do
  clean true
  action :start
end

wlp_server "myInstance" do
  action :stop
end

wlp_server "myInstance" do
  action :destroy
end
```

## wlp_server_env

Adds, removes, and sets environment properties in installation-wide or instance-specific server.env file.

### Actions

- set: Set environment properties in a server.env file. Other existing properties in the file are not preserved. Default action.
- add: Adds environment properties to a server.env file. Other existing properties in the file are preserved.
- remove: Removes environment properties from a server.env file. Other existing properties in the file are preserved.

### Attribute Parameters

- server_name: If specified, the server.env file in the specified server instance is updated. Otherwise, the installation-wide server.env file is updated. Defaults to <code>nil</code>.
- properties: The properties to add, set, or remove. Must be specified as a hash when adding or setting, and as an array when removing. Defaults to <code>nil</code>.

### Examples
```ruby
wlp_server_env "add to instance-specific server.env" do
  server_name "myInstance"
  properties "JAVA_HOME" => "/usr/lib/j2sdk1.7-ibm/"
  action :add
end

wlp_server_env "remove from instance-specific server.env" do
  server_name "myInstance"
  properties [ "JAVA_HOME" ]
  action :remove
end

wlp_server_env "set installation-wide server.env" do
  properties "WLP_USER_DIR" => "/var/wlp"
  action :set
end

wlp_server_env "remove from installation-wide server.env" do
  properties [ "WLP_USER_DIR" ]
  action :remove
end
```

# Contributing

Please see our [contributing guide](https://github.com/WASdev/ci.chef.wlp/blob/master/CONTRIBUTING.md).


# Support

Use the [issue tracker][] for reporting any bugs or enhancements. For any questions please use the [WASdev forum](https://developer.ibm.com/answers/?community=wasdev).

[issue tracker]: https://github.com/WASdev/ci.chef.wlp/issues

The cookbook is maintained by IBM.

# Notice

(C) Copyright IBM Corporation 2013, 2014.

# License

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
