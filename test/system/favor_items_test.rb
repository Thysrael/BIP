require "application_system_test_case"

class FavorItemsTest < ApplicationSystemTestCase
  setup do
    @favor_item = favor_items(:one)
  end

  test "visiting the index" do
    visit favor_items_url
    assert_selector "h1", text: "Favor items"
  end

  test "should create favor item" do
    visit favor_items_url
    click_on "New favor item"

    fill_in "Product", with: @favor_item.product_id
    fill_in "User", with: @favor_item.user_id
    click_on "Create Favor item"

    assert_text "Favor item was successfully created"
    click_on "Back"
  end

  test "should update Favor item" do
    visit favor_item_url(@favor_item)
    click_on "Edit this favor item", match: :first

    fill_in "Product", with: @favor_item.product_id
    fill_in "User", with: @favor_item.user_id
    click_on "Update Favor item"

    assert_text "Favor item was successfully updated"
    click_on "Back"
  end

  test "should destroy Favor item" do
    visit favor_item_url(@favor_item)
    click_on "Destroy this favor item", match: :first

    assert_text "Favor item was successfully destroyed"
  end
end
