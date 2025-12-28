"use client";

import { useState, useEffect, useCallback } from "react";
import { Button } from "@/components/ui/button";
import { ArrowRight } from "lucide-react";

export function StickyMobileCTA() {
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    let timeoutId: NodeJS.Timeout;
    const handleScroll = () => {
      // Throttle scroll events for performance
      clearTimeout(timeoutId);
      timeoutId = setTimeout(() => {
        // Show after scrolling 500px, hide when at pricing section
        const pricingSection = document.getElementById("pricing");
        const pricingTop = pricingSection?.getBoundingClientRect().top ?? Infinity;
        const pricingBottom = pricingSection?.getBoundingClientRect().bottom ?? Infinity;

        // Hide when pricing is fully in view
        const isPricingVisible = pricingTop < window.innerHeight && pricingBottom > 0;
        setIsVisible(window.scrollY > 500 && !isPricingVisible);
      }, 50);
    };

    window.addEventListener("scroll", handleScroll, { passive: true });
    return () => {
      window.removeEventListener("scroll", handleScroll);
      clearTimeout(timeoutId);
    };
  }, []);

  const scrollToPricing = useCallback(() => {
    const pricingSection = document.getElementById("pricing");
    if (pricingSection) {
      pricingSection.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  }, []);

  if (!isVisible) return null;

  return (
    <div
      className="fixed bottom-0 left-0 right-0 z-50 md:hidden bg-background/95 backdrop-blur-sm border-t border-border p-4 shadow-lg"
      role="complementary"
      aria-label="Quick access to pricing"
    >
      <Button
        className="w-full"
        size="lg"
        onClick={scrollToPricing}
        aria-label="View pricing options - $39 one-time payment"
      >
        Get Pack Leader - $39
        <ArrowRight className="ml-2 h-4 w-4" aria-hidden="true" />
      </Button>
      <p className="text-xs text-center mt-2 text-muted-foreground">
        One-time payment • 30-day guarantee
      </p>
    </div>
  );
}
