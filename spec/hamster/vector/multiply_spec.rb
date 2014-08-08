require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#*" do
    before do
      @vector = Hamster.vector(1, 2, 3)
    end

    context "with a String argument" do
      it "acts just like #join" do
        (@vector * 'boo').should eql(@vector.join('boo'))
      end
    end

    context "with an Integer argument" do
      it "concatenates n copies of the array" do
        (@vector * 0).should eql(Hamster.vector)
        (@vector * 1).should eql(@vector)
        (@vector * 2).should eql(Hamster.vector(1,2,3,1,2,3))
        (@vector * 3).should eql(Hamster.vector(1,2,3,1,2,3,1,2,3))
      end

      it "raises an ArgumentError if integer is negative" do
        -> { @vector * -1 }.should raise_error(ArgumentError)
      end
    end

    context "with a subclass of Vector" do
      it "returns an instance of the subclass" do
        subclass = Class.new(Hamster::Vector)
        instance = subclass.new([1,2,3])
        (instance * 10).class.should be(subclass)
      end
    end

    it "raises a TypeError if passed nil" do
      -> { @vector * nil }.should raise_error(TypeError)
    end

    it "raises an ArgumentError if passed no arguments" do
      -> { @vector.* }.should raise_error(ArgumentError)
    end
  end
end