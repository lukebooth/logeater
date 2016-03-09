require "test_helper"

class ParamsParserTest < ActiveSupport::TestCase


  context "Given a simple hash, it" do
    should "parse it" do
      assert_parses '{"utf8"=>"✓"}' => {"utf8"=>"✓"}
    end

    should "handle integers" do
      assert_parses '{"person_id"=>10}' => {"person_id"=>10}
    end

    should "handle floats" do
      assert_parses '{"person_id"=>10.56}' => {"person_id"=>10.56}
    end

    should "handle negatives" do
      assert_parses '{"person_id"=>-10}' => {"person_id"=>-10}
      assert_parses '{"person_id"=>-10.56}' => {"person_id"=>-10.56}
    end

    should "handle booleans" do
      assert_parses '{"visible"=>true}' => {"visible"=>true}
    end

    should "handle nil" do
      assert_parses '{"visible"=>nil}' => {"visible"=>nil}
    end

    should "handle arrays" do
      assert_parses '{"ids"=>[1, 4]}' => {"ids"=>[1,4]}
    end



    should "handle empty strings" do
      assert_parses '{"visible"=>""}' => {"visible"=>""}
    end

    should "handle empty arrays" do
      assert_parses '{"array"=>[]}' => {"array"=>[]}
    end

    should "handle empty hashes" do
      assert_parses '{"hash"=>{}}' => {"hash"=>{}}
    end
  end


  context "Given a hash with more than one key, it" do
    should "parse it" do
      assert_parses '{"utf8"=>"✓", "authenticity_token"=>"kDM07..."}' => {"utf8"=>"✓", "authenticity_token"=>"kDM07..."}
    end
  end


  context "Given a hash with a nested hash, it" do
    should "handle nested hashes" do
      assert_parses '{"person"=>{"name"=>"Tim"}}' => {"person"=>{"name"=>"Tim"}}
    end

    should "handle arrays of nested hashes" do
      assert_parses '{"people"=>[{"id"=>1},{"id"=>2}]}' => {"people"=>[{"id"=>1},{"id"=>2}]}
    end
  end


  context "Given a hash with a serialized Ruby object, it" do
    should "parse it" do
      assert_parses '{"tempfile"=>#<Tempfile:/tmp/RackMultipart20141213-1847-1c8fpzw>}' => {"tempfile"=>"Tempfile"}
    end

    should "ignore the object's ivars" do
      assert_parses '{"photo"=>#<ActionDispatch::Http::UploadedFile:0x007f7c685318a8 @tempfile=#<Tempfile:/tmp/RackMultipart20141213-1847-1c8fpzw>, @original_filename="Martin-008.JPG", @content_type="image/jpeg", @headers="Content-Disposition: form-data; name=\"person[photo]\"; filename=\"Martin-008.JPG\"\\r\\nContent-Type: image/jpeg\\r\\n\">}' => {"photo"=>"ActionDispatch::Http::UploadedFile"}
    end
  end


  context "Given an invalid input, it" do
    should "raise MalformedParameters" do
      assert_raises Logeater::Parser::MalformedParameters do
        parse! '{"nope"=>}'
      end
    end
  end


private

  def assert_parses(params)
    value, result = params.to_a[0]
    assert_equal result, parse!(value)
  end

  def parse!(value)
    Logeater::ParamsParser.new(value).parse!
  end

end
