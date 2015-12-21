require 'spec_helper'
describe 'rsnapshot' do

  {'Ubuntu' => 'Debian', 'Debian' => 'Debian'}.each do |system, family|
    context "when on system #{system} no lvm" do
      let :facts do
        {
          :osfamily        => family,
          :operatingsystem => system,
        }
      end

      it { should contain_class('rsnapshot') }
      it { should contain_class('rsnapshot::install') }
      it { should contain_class('rsnapshot::config') }
    end

    context "when on system #{system} with lvm" do
      let :facts do
        {
          :osfamily        => family,
          :operatingsystem => system,
        }
      end

      let(:params) { {:use_lvm => true} }

      it { should contain_class('rsnapshot') }
      it { should contain_class('rsnapshot::install') }
      it { should contain_class('rsnapshot::config') }

      it {
        should contain_file('/etc/rsnapshot.conf').with_content(/^linux_lvm_((\w|_)+)\t(.*)$/)
      }
    end
  end
end
