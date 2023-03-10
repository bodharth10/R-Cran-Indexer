require 'rails_helper'
require 'spec_helper.rb'

RSpec.describe Package, type: :model do
  # validations
  it { should validate_uniqueness_of(:name) }

  context 'when saving a package' do
    let(:package) { Package.new(name:"A3", title: "Accurate,,Adaptable,,and,Accessible,Error,Metrics,for,Predictive", version:"1.0.0", author: "Scott,Fortmann-Roe", license: "GPL,(>=,2)", publication:"2015-08-16,23:05:52", maintainer:"Scott,Fortmann-Roe,<scottfr@berkeley.edu>", dependencies: "R,(>=,2.15.0),,xtable,,pbapply")}

    it 'saves the package' do
      expect { package.save }.to change(Package, :count).by(1)
    end

    it 'does not save the package if the name is blank' do
      package.name = ''
      expect(package.save).to be_falsey
    end
  end
end