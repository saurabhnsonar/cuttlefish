require "spec_helper"

describe EmailDataCache do
  describe "#update" do
    it "should persist the main part of the email in the filesystem" do
      cache = EmailDataCache.new(mock(id: 10, data: "This is a main data section"))
      cache.update
      File.read(cache.data_filesystem_path).should == "This is a main data section"
    end

    it "should only keep the full data of a certain number of the emails around" do
      EmailDataCache.stub!(:max_no_emails_to_store_data).and_return(2)
      (1..4).each {|id| EmailDataCache.new(mock(id: id, data: "This a main section")).update }
      Dir.glob(File.join(EmailDataCache.data_filesystem_directory, "*")).count.should == 2
    end    
  end

  describe "data" do
    it "should be able to read in the data again" do
      EmailDataCache.new(mock(id: 10, data: "This is a main data section")).update
      EmailDataCache.new(mock(id: 10)).data.should == "This is a main data section"
    end

    it "should return nil if nothing is stored on the filesystem" do
      EmailDataCache.new(mock(id: 10)).data.should be_nil
    end
  end
end