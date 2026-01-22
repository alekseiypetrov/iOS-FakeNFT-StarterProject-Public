enum AccessibilityIdentifier {
    enum BasketView {
        static let confirmingDeleteButton = "confirmingDeleteButton"
        static let paymentButton = "navigateToPay"
        static let deleteButtonInCell = "delete"
        static let titleOfEmptyList = "titleOfEmptyBasket"
    }
    enum PaymentView {
        static let paymentButton = "confirmAndExecutePayment"
    }
    enum SuccessfulPaymentView {
        static let imageView = "imageOfSuccessfulPayment"
        static let label = "titleOfSuccessfulPayment"
        static let button = "backToBasketButton"
    }
}
