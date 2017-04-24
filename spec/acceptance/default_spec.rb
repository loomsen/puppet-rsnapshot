require 'spec_helper_acceptance'

describe 'rsnapshot' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-EOS
        class { 'rsnapshot':
         hosts => {
         'localhost' => {},
         'example.com'    => {
           backup_defaults => false,
           backup          => {
            '/var/'       => './'
           }
          }
         }
        }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'packages installed' do
    describe package('rsnapshot') do
      it { is_expected.to be_installed }
    end
  end
  context 'files provisioned' do
    describe file('/etc/tmpfiles.d/rsnapshot.conf') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'D /var/run/rsnapshot 0755 root root -' }
    end
    describe file('/etc/rsnapshot/localhost.rsnapshot.conf') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'backup' }
    end
    describe file('/etc/rsnapshot/example.com.rsnapshot.conf') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'backup' }
    end
    describe file('/etc/rsnapshot.conf') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'localhost' }
      its(:content) { is_expected.to match 'example.com' }
    end
    describe file('/etc/rsnapshot/localhost.rsnapshot.conf') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'backup' }
    end
      describe file('/etc/cron.d/example_com') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'example.com' }
    end
  end
end
