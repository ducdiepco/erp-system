require "spec_helper"

RSpec.describe PaymentApi::Views::ApplicationLayout, type: :view do
  let(:layout)   { PaymentApi::Views::ApplicationLayout.new(template, {}) }
  let(:rendered) { layout.render }
  let(:template) { Hanami::View::Template.new('apps/payment_api/templates/application.html.haml') }

  it 'contains application name' do
    expect(rendered).to include('PaymentApi')
  end
end
