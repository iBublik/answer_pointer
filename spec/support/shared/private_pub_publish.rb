shared_examples_for 'publishable' do
  it 'should publish to PrivatePub channel when params are valid' do
    expect(PrivatePub).to receive(:publish_to).with(publish_path, anything)
    request
  end

  it 'should not publish to PrivatePub channel when params are invalid' do
    expect(PrivatePub).to_not receive(:publish_to)
    invalid_params_request
  end
end
