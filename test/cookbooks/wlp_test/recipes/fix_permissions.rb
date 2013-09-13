# Cookbook Name:: wlp_test
# Attributes:: setup_cache
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Work-around for https://github.com/opscode/test-kitchen/issues/186
if node[:wlp_test][:fix_permissions][:enabled]
  ruby_block "fix permissions" do
    block do
      dir = Chef::Config[:file_cache_path]
      begin
        Chef::Log.info "Updated permissions for #{dir}"
        ::FileUtils.chmod("o+rx", dir)
        dir = ::File.dirname(dir)
      end while dir != "/"
    end
  end
end