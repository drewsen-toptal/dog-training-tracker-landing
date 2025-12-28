"use client";

import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { ArrowRight } from "lucide-react";

export function StickyMobileCTA() {
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      // Show after scrolling 500px
      setIsVisible(window.scrollY > 500);
    };
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  if (!isVisible) return null;

  return (
    <div className="fixed bottom-0 left-0 right-0 z-50 md:hidden bg-background/95 backdrop-blur-sm border-t border-border p-4 shadow-lg">
      <Button className="w-full" size="lg">
        Get Pack Leader - $39
        <ArrowRight className="ml-2 h-4 w-4" />
      </Button>
      <p className="text-xs text-center mt-2 text-muted-foreground">
        One-time payment • 30-day guarantee
      </p>
    </div>
  );
}
