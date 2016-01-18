require 'spec_helper'
describe 'rsnapshot' do
      it { should contain_class('rsnapshot::params') }
      it { is_expected.to compile  }
      it { is_expected.to contain_class('rsnapshot::config')  }
      it { is_expected.to contain_class('rsnapshot::install')  }
end
