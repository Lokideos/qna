shared_examples_for "Ratable" do
  it "creates new rating" do  
    objects_assign  
    expect(@assigned_object.ratings.first).to eq nil
    do_request
    @assigned_object.reload
    expect(@assigned_object.ratings.first).to_not eq nil
  end

  it "changes rating's value" do
    objects_assign
    do_request
    @assigned_object.reload
    expect(@assigned_object.ratings.first.value).to eq @final_rating_value
  end
end
