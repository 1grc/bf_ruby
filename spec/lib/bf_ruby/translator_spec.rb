# frozen_string_literal: true

RSpec.describe BfRuby::Translator do
  TEST_DATA_PATH = "#{File.dirname(__FILE__)}/../../test_data"

  def load_test_data(file_name)
    File.open("#{TEST_DATA_PATH}/#{file_name}").read
  end

  describe '.translate' do
    subject(:translate_src) { BfRuby::Translator.translate(src) }

    context 'When "hello_world" operation is loaded' do
      let!(:src) do
        load_test_data('hello_world.bf')
      end

      it 'return Hello World!\n' do
        expect(translate_src).to eq "Hello World!\n"
      end
    end

    context 'When "rot13" operation is loaded' do
      let!(:src) do
        load_test_data('rot13.bf')
      end

      it 'raise NotImplementedError' do
        expect { translate_src }.to raise_error(NotImplementedError)
      end
    end
  end
end
