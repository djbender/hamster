require 'spec_helper'

require 'hamster/hash'

describe "Hamster.Hash" do

  [:merge, :+].each do |method|

    describe "##{method}" do

      [
        [[], [], []],
        [["A" => "aye"], [], ["A" => "aye"]],
        [["A" => "aye"], ["A" => "bee"], ["A" => "bee"]],
        [["A" => "aye"], ["B" => "bee"], ["A" => "aye", "B" => "bee"]],
      ].each do |a, b, expected|

        describe "for #{a.inspect} and #{b.inspect}" do

          before do
            @result = Hamster.Hash(*a).send(method, Hamster.Hash(*b))
          end

          it "returns #{expected.inspect}"  do
            @result.should == Hamster.Hash(*expected)
          end

        end

      end

    end

  end

end
