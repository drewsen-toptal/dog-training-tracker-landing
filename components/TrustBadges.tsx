import { Shield, Lock, CreditCard, Apple } from "lucide-react";

export function TrustBadges() {
  return (
    <div className="flex flex-wrap items-center justify-center gap-6 py-4">
      <div className="flex items-center gap-2 text-muted-foreground">
        <Lock className="h-4 w-4" />
        <span className="text-xs">256-bit SSL</span>
      </div>
      <div className="flex items-center gap-2 text-muted-foreground">
        <CreditCard className="h-4 w-4" />
        <span className="text-xs">Secure Checkout</span>
      </div>
      <div className="flex items-center gap-2 text-muted-foreground">
        <Apple className="h-4 w-4" />
        <span className="text-xs">Apple Pay</span>
      </div>
      <div className="flex items-center gap-2 text-muted-foreground">
        <Shield className="h-4 w-4" />
        <span className="text-xs">Money-Back Guarantee</span>
      </div>
    </div>
  );
}
