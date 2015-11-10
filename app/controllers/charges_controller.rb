class ChargesController < ApplicationController

  def new
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "BigMoney Membership - #{current_user.name}",
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
      description: "Ultimate Membership - #{current_user.email}",
      currency: 'usd'
    )

    if current_user.update(role: 'ultimate')
      flash[:success] = "Thank you for upgrading to the Ultimate Membership, #{current_user.email}!"
      redirect_to edit_user_registration_path
    else
      flash[:error] = "There was an error upgrading your account."
      redirect_to edit_user_registration_path
    end

    flash[:notice] = "Thanks for all the money, #{current_user.email}! Feel free to pay me again."
    redirect_to user_path(current_user)

    # Stripe will send back CardErrors, with friendly messages
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
    end
  end
