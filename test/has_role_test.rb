require "test/test_helper"

class HasRoleTest < ActiveSupport::TestCase

  context "Objects that have an aegis role" do

    setup do
      @guest = User.new(:role_name => "guest")
      @student = User.new(:role_name => "student")
      @student_subclass = UserSubclass.new(:role_name => "student")
      @admin = User.new(:role_name => "admin")
    end

    should "know their role" do
      assert :guest, @guest.role.name
      assert :student, @student.role.name
      assert :student_subclass, @student.role.name
      assert :admin, @admin.role.name
    end

    should "know if they belong to a role" do
      assert @guest.guest?
      assert !@guest.student?
      assert !@guest.admin?
      assert !@student.guest?
      assert !@student_subclass.guest?
      assert @student.student?
      assert @student_subclass.student?
      assert !@student.admin?
      assert !@student_subclass.admin?
      assert !@admin.guest?
      assert !@admin.student?
      assert @admin.admin?
    end

    should "still behave as usual when a method ending in a '?' does not map to a role query" do
      assert_raise NoMethodError do
        @guest.nonexisting_method?
      end
    end

    should "have a default role" do
      assert :guest, User.new(:role_name => nil).role.name
    end

    should "know that they respond to permission methods" do
      assert @guest.respond_to?(:may_foo?)
      assert @guest.respond_to?(:may_foo!)
    end

    should "retain the usual respond_to behaviour for non-permission methods" do
      assert !@guest.respond_to?(:nonexisting_method)
      assert @guest.respond_to?(:to_s)
    end

  end

end
