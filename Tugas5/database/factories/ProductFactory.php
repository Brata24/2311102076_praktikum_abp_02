<?php

namespace Database\Factories;

use App\Models\Product;
use Illuminate\Database\Eloquent\Factories\Factory;

class ProductFactory extends Factory
{
    protected $model = Product::class;

    public function definition(): array
    {
        $categories = ['Minuman', 'Makanan', 'Snack', 'Peralatan', 'Kosmetik'];

        return [
            'name' => $this->faker->words(2, true),
            'sku' => strtoupper($this->faker->unique()->bothify('??-#####')),
            'category' => $this->faker->randomElement($categories),
            'description' => $this->faker->sentence(10),
            'price' => $this->faker->numberBetween(5000, 150000),
            'stock' => $this->faker->numberBetween(0, 50),
            'is_active' => $this->faker->boolean(80),
        ];
    }
}
