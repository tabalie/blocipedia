class ChargesController < ApplicationController

  def new
    @stripe_btn_data = {
      key: Rails.configuration.stripe[:stripe_publishable_key],
      description: "Premium Membership - #{current_user.name}",
      amount: 10_00
    }
  end

  def create
    # Creates a Stripe Customer object, for associating
    # with the charge (1000 pennies or 10 bucks)
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )

    # Where the real magic happens
    charge = Stripe::Charge.create(
      customer: customer.id, # Note -- this is NOT the user_id in your app
      amount: 10_00,
      description: "Premium Membership - #{current_user.email}",
      currency: 'usd'
    )

    if current_user.make_premium
      flash[:success] = "Thank you for upgrading to the Premium Membership, #{current_user.email}! You now can have private wikis and invite collaborators to work on your wikis."
      redirect_to edit_user_registration_path
    else
      flash[:error] = "There was an error upgrading your account to Premium Membership. Your membership is still a Standard membership."
      redirect_to edit_user_registration_path
    end

    # Stripe will send back CardErrors, with friendly messages
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
    end
  end
