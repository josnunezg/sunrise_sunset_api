class CreateSunriseSunsetInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :sunrise_sunset_infos do |t|
      t.date :date
      t.string :sunrise
      t.string :sunset
      t.string :first_light
      t.string :last_light
      t.string :dawn
      t.string :dusk
      t.string :solar_noon
      t.string :golden_hour
      t.string :day_length
      t.string :timezone
      t.integer :utc_offset
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      t.timestamps
    end

    add_index :sunrise_sunset_infos, [ :date, :latitude, :longitude ], unique: true
  end
end
