# encoding: utf-8
#
# Licensed to the Software Freedom Conservancy (SFC) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The SFC licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require_relative '../spec_helper'

module Selenium
  module WebDriver
    describe Firefox, only: {browser: %i[firefox ff_nightly]} do
      it 'creates default capabilities', except: {driver: :remote}, only: {browser: :firefox} do
        create_driver! do
          caps = driver.capabilities
          expect(caps.proxy).to be_nil
          expect(caps.platform_name).to_not be_nil
          expect(caps.browser_version).to match(/^\d\d\./)
          expect(caps.platform_version).to_not be_nil

          expect(caps.remote_session_id).to be_nil
        end
      end

      it 'creates default capabilities', except: {driver: :remote}, only: {browser: :ff_nightly} do
        create_driver! do
          caps = driver.capabilities
          expect(caps.proxy).to be_nil
          expect(caps.platform_name).to_not be_nil
          expect(caps.browser_version).to match(/^\d\d\./)
          expect(caps.platform_version).to_not be_nil

          expect(caps.accept_insecure_certs).to be == false
          expect(caps.page_load_strategy).to be == 'normal'
          expect(caps.accessibility_checks).to be == false
          expect(caps.implicit_timeout).to be == 0
          expect(caps.page_load_timeout).to be == 300000
          expect(caps.script_timeout).to be == 30000

          expect(caps.remote_session_id).to be_nil
        end
      end

      it 'creates default capabilities', except: {driver: :remote}, only: {browser: :ff_esr} do
        create_driver! do
          caps = driver.capabilities
          expect(caps.proxy).to be_nil
          expect(caps.platform_name).to_not be_nil
          expect(caps.browser_version).to match(/^\d\d\./)
          expect(caps.platform_version).to_not be_nil

          expect(caps.remote_session_id).to be_nil

          expect(caps.rotatable).to be == false
        end
      end

      # Remote needs to implement firefox options
      it 'takes a binary path as an argument', except: {driver: :remote} do
        pending "Set ENV['ALT_FIREFOX_BINARY'] to test this" unless ENV['ALT_FIREFOX_BINARY']

        begin
          path = Firefox::Binary.path

          create_driver! do
            default_version = driver.capabilities.version
            expect { driver.capabilities.browser_version }.to_not raise_exception
          end

          caps = Remote::Capabilities.firefox(firefox_options: {binary: ENV['ALT_FIREFOX_BINARY']})
          create_driver!(desired_capabilities: caps) do
            expect(driver.capabilities.version).to_not eql(default_version)
            expect { driver.capabilities.browser_version }.to_not raise_exception
          end
        ensure
          Firefox::Binary.path = path
        end
      end

      it 'gives precedence to firefox options versus argument switch' do
        pending "Set ENV['ALT_FIREFOX_BINARY'] to test this" unless ENV['ALT_FIREFOX_BINARY']

        begin
          path = Firefox::Binary.path

          create_driver! do
            default_version = driver.capabilities.version
            expect { driver.capabilities.browser_version }.to_not raise_exception
          end

          caps = Remote::Capabilities.firefox(firefox_options: {binary: ENV['ALT_FIREFOX_BINARY']},
                                              service_args: {binary: path})
          create_driver!(desired_capabilities: caps) do
            expect(driver.capabilities.version).to_not eql(default_version)
            expect { driver.capabilities.browser_version }.to_not raise_exception
          end
        ensure
          Firefox::Binary.path = path
        end
      end
    end
  end # WebDriver
end # Selenium
