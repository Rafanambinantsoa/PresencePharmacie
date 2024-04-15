import { defineStore } from 'pinia';

export const useCartStore = defineStore('cart', () => {
    const cartItems = ref([]); // Tableau pour stocker les articles du panier

    // Getter pour obtenir le nombre total d'articles dans le panier
    const totalItems = computed(() => cartItems.value.length);

    // Getter pour obtenir le prix total du panier
    const totalPrice = computed(() =>
        cartItems.value.reduce((total, item) => total + (item.prix * item.quantity), 0)
    );


    // Fonction pour obtenir un article du panier en fonction de son ID
    function getItem(itemId) {
        return cartItems.value.find(item => item.id === itemId);
    }

    // Fonction pour ajouter un article au panier
    function addToCart(item) {
        cartItems.value.push(item);

    }

    // Fonction pour supprimer un article du panier en fonction de son ID
    function removeFromCart(itemId) {
        cartItems.value = cartItems.value.filter(item => item.id !== itemId);
    }

    // Fonction pour vider complètement le panier
    function clearCart() {
        cartItems.value = [];
    }

    // Fonction pour vérifier si un article existe déjà dans le panier
    function isItemInCart(itemId) {
        return cartItems.value.some(item => item.id === itemId);
    }

    // Fonction pour augmenter la quantité d'un article dans le panier et aussi que la quantité ne doit pas depasser  items.limitBillets et aussi qu'on diminue la quantité d'un article dans le panier
    function increaseQuantity(itemId) {
        const item = cartItems.value.find(item => item.id === itemId);
        if (item && item.quantity < item.limitBillets) {
            item.quantity++;
        }
        
    }

    // Fonction pour diminuer la quantité d'un article dans le panier
    function decreaseQuantity(itemId) {
        const item = cartItems.value.find(item => item.id === itemId);
        if (item && item.quantity > 1) {
            item.quantity--;
        }
    }

    return {
        cartItems,
        getItem,
        totalItems,
        totalPrice,
        addToCart,
        removeFromCart,
        clearCart,
        isItemInCart,
        increaseQuantity,
        decreaseQuantity
    };
});
