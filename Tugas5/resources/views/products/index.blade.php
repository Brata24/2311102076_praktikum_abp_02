<x-app-layout>
    <x-slot name="header">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
                <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
                    {{ __('Inventaris Produk') }}
                </h2>
                <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
                    Kelola produk Pak Cokomi dan Mas Wowo untuk toko inventaris.
                </p>
            </div>

            <div class="flex items-center gap-2">
                <a href="{{ route('products.create') }}" class="inline-flex items-center px-4 py-2 bg-indigo-600 border border-transparent rounded-md font-semibold text-sm text-white hover:bg-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 dark:focus:ring-offset-gray-900 transition">
                    {{ __('Tambah Produk') }}
                </a>
            </div>
        </div>
    </x-slot>

    <div class="py-6">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900 dark:text-gray-100">
                    <div class="space-y-6">
                        @if (session('success'))
                            <div class="rounded-lg bg-emerald-50 border border-emerald-200 p-4 text-sm text-emerald-700 dark:bg-emerald-900/30 dark:border-emerald-700 dark:text-emerald-200">
                                {{ session('success') }}
                            </div>
                        @endif

                        <form method="GET" action="{{ route('products.index') }}" class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
                            <div class="w-full sm:w-1/2">
                                <input
                                    type="text"
                                    name="search"
                                    value="{{ $search ?? '' }}"
                                    placeholder="Cari nama, SKU, atau kategori..."
                                    class="w-full rounded-md border border-gray-300 px-4 py-2 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 dark:bg-gray-900 dark:border-gray-700 dark:text-gray-100"
                                >
                            </div>
                            <button type="submit" class="inline-flex items-center justify-center rounded-md bg-indigo-600 px-4 py-2 text-sm font-semibold text-white hover:bg-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 dark:focus:ring-offset-gray-900">
                                {{ __('Cari Produk') }}
                            </button>
                        </form>

                        <div class="overflow-hidden rounded-lg border border-gray-200 dark:border-gray-700">
                            <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                                <thead class="bg-gray-50 dark:bg-gray-900">
                                    <tr>
                                        <th class="px-4 py-3 text-left text-xs font-medium uppercase tracking-wide text-gray-500 dark:text-gray-300">{{ __('SKU') }}</th>
                                        <th class="px-4 py-3 text-left text-xs font-medium uppercase tracking-wide text-gray-500 dark:text-gray-300">{{ __('Nama') }}</th>
                                        <th class="px-4 py-3 text-left text-xs font-medium uppercase tracking-wide text-gray-500 dark:text-gray-300">{{ __('Kategori') }}</th>
                                        <th class="px-4 py-3 text-right text-xs font-medium uppercase tracking-wide text-gray-500 dark:text-gray-300">{{ __('Stok') }}</th>
                                        <th class="px-4 py-3 text-right text-xs font-medium uppercase tracking-wide text-gray-500 dark:text-gray-300">{{ __('Harga') }}</th>
                                        <th class="px-4 py-3 text-center text-xs font-medium uppercase tracking-wide text-gray-500 dark:text-gray-300">{{ __('Status') }}</th>
                                        <th class="px-4 py-3 text-center text-xs font-medium uppercase tracking-wide text-gray-500 dark:text-gray-300">{{ __('Aksi') }}</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-200 bg-white dark:divide-gray-700 dark:bg-gray-800">
                                    @forelse ($products as $product)
                                        <tr>
                                            <td class="px-4 py-4 text-sm text-gray-700 dark:text-gray-200">{{ $product->sku }}</td>
                                            <td class="px-4 py-4 text-sm text-gray-700 dark:text-gray-200">{{ $product->name }}</td>
                                            <td class="px-4 py-4 text-sm text-gray-700 dark:text-gray-200">{{ $product->category }}</td>
                                            <td class="px-4 py-4 text-right text-sm text-gray-700 dark:text-gray-200">{{ $product->stock }}</td>
                                            <td class="px-4 py-4 text-right text-sm text-gray-700 dark:text-gray-200">Rp {{ number_format($product->price, 0, ',', '.') }}</td>
                                            <td class="px-4 py-4 text-center text-sm">
                                                <span class="inline-flex rounded-full px-2 py-1 text-xs font-semibold {{ $product->is_active ? 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/50 dark:text-emerald-200' : 'bg-red-100 text-red-700 dark:bg-red-900/50 dark:text-red-200' }}">
                                                    {{ $product->is_active ? __('Aktif') : __('Nonaktif') }}
                                                </span>
                                            </td>
                                            <td class="px-4 py-4 text-center text-sm text-gray-700 dark:text-gray-200">
                                                <div class="inline-flex items-center gap-2">
                                                    <a href="{{ route('products.edit', $product) }}" class="rounded-md bg-sky-600 px-3 py-1 text-xs font-semibold text-white hover:bg-sky-500">
                                                        {{ __('Edit') }}
                                                    </a>
                                                    <button
                                                        type="button"
                                                        x-data="{}"
                                                        @click="$dispatch('open-delete-modal', { action: '{{ route('products.destroy', $product) }}', name: '{{ addslashes($product->name) }}' })"
                                                        class="rounded-md bg-red-600 px-3 py-1 text-xs font-semibold text-white hover:bg-red-500"
                                                    >
                                                        {{ __('Hapus') }}
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    @empty
                                        <tr>
                                            <td colspan="7" class="px-4 py-8 text-center text-sm text-gray-500 dark:text-gray-400">
                                                {{ __('Belum ada produk. Tambahkan produk baru untuk memulai inventaris toko.') }}
                                            </td>
                                        </tr>
                                    @endforelse
                                </tbody>
                            </table>
                        </div>

                        <div class="mt-4">
                            {{ $products->links() }}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div x-data="{ open: false, action: '', productName: '' }"
         @open-delete-modal.window="open = true; action = $event.detail.action; productName = $event.detail.name;"
         x-cloak
    >
        <div x-show="open" class="fixed inset-0 z-40 bg-black/30 backdrop-blur-sm"></div>
        <div x-show="open" class="fixed inset-0 z-50 flex items-center justify-center p-4">
            <div class="w-full max-w-lg rounded-2xl bg-white p-6 shadow-xl dark:bg-gray-900">
                <h3 class="text-lg font-semibold text-gray-900 dark:text-gray-100">{{ __('Konfirmasi Hapus Produk') }}</h3>
                <p class="mt-2 text-sm text-gray-600 dark:text-gray-300">
                    {{ __('Anda akan menghapus produk berikut:') }}
                    <strong x-text="productName"></strong>
                </p>

                <div class="mt-6 flex justify-end gap-2">
                    <button type="button" @click="open = false" class="rounded-md border border-gray-300 px-4 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-50 dark:border-gray-700 dark:text-gray-200 dark:hover:bg-gray-800">
                        {{ __('Batal') }}
                    </button>

                    <form :action="action" method="POST">
                        @csrf
                        @method('DELETE')

                        <button type="submit" class="rounded-md bg-red-600 px-4 py-2 text-sm font-semibold text-white hover:bg-red-500">
                            {{ __('Hapus Produk') }}
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>
