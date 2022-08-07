module Api
    module V1
        class ReportsController < ApplicationController
            def index             
                @current_date = Date.today                

                render json: {
                    users_on_vacation: "#{users_on_vacation}%",
                    active_users: "#{active_users}%",
                    average_equipment_per_user: average_equipment_per_user,
                    total_equipment_blocked_price: total_equipment_blocked_price
                }
            end

            private

            def users_on_vacation
                total_users = User.count.to_f
                amount_in_vacation = User.joins(:vacation)
                                         .where("vacations.start_date <= ? AND vacations.end_date >= ?", @current_date, @current_date)
                                         .count
                                         .to_f

                100 * (amount_in_vacation / total_users)
            end

            def active_users
                100.0 - users_on_vacation
            end

            def average_equipment_per_user
                Product.count / User.count
            end

            def total_equipment_blocked_price
                User.joins(:vacation, :products).where("start_date <= ? AND end_date >= ?", @current_date, @current_date).sum(:price)
            end
        end
    end
end
