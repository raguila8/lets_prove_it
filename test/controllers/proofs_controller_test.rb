require 'test_helper'

class ProofsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @proof = proofs(:one)
  end

  test "should get index" do
    get proofs_url
    assert_response :success
  end

  test "should get new" do
    get new_proof_url
    assert_response :success
  end

  test "should create proof" do
    assert_difference('Proof.count') do
      post proofs_url, params: { proof: { content: @proof.content } }
    end

    assert_redirected_to proof_url(Proof.last)
  end

  test "should show proof" do
    get proof_url(@proof)
    assert_response :success
  end

  test "should get edit" do
    get edit_proof_url(@proof)
    assert_response :success
  end

  test "should update proof" do
    patch proof_url(@proof), params: { proof: { content: @proof.content } }
    assert_redirected_to proof_url(@proof)
  end

  test "should destroy proof" do
    assert_difference('Proof.count', -1) do
      delete proof_url(@proof)
    end

    assert_redirected_to proofs_url
  end
end
