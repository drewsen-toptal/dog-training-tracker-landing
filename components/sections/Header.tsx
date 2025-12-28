"use client";

import { useState, useCallback, useRef, useEffect } from "react";
import { Menu, Dog, Sparkles, DollarSign, Star, HelpCircle, Shield } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Sheet,
  SheetContent,
  SheetTrigger,
  SheetTitle,
  SheetDescription,
} from "@/components/ui/sheet";

const navLinks = [
  { href: "#features", label: "Features", icon: Sparkles, description: "What makes us different" },
  { href: "#pricing", label: "Pricing", icon: DollarSign, description: "One-time payment, lifetime access" },
  { href: "#testimonials", label: "Reviews", icon: Star, description: "What dog owners say" },
  { href: "#faq", label: "FAQ", icon: HelpCircle, description: "Common questions answered" },
];

export function Header() {
  const [isOpen, setIsOpen] = useState(false);
  const firstNavLinkRef = useRef<HTMLAnchorElement>(null);

  const scrollToPricing = useCallback(() => {
    setIsOpen(false);
    // Small delay to allow sheet to close before scrolling
    setTimeout(() => {
      const pricingSection = document.getElementById("pricing");
      if (pricingSection) {
        pricingSection.scrollIntoView({ behavior: "smooth", block: "start" });
      }
    }, 100);
  }, []);

  // Focus first nav link when sheet opens
  useEffect(() => {
    if (isOpen && firstNavLinkRef.current) {
      // Small delay to ensure sheet is rendered
      setTimeout(() => {
        firstNavLinkRef.current?.focus();
      }, 100);
    }
  }, [isOpen]);

  return (
    <header className="sticky top-0 z-50 w-full border-b border-border/40 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container mx-auto flex h-16 items-center justify-between px-4 md:px-6">
        {/* Logo */}
        <a href="/" className="flex items-center gap-2">
          <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary" aria-hidden="true">
            <Dog className="h-5 w-5 text-primary-foreground" />
          </div>
          <span className="text-lg font-semibold">Puppy Pro</span>
        </a>

        {/* Desktop Nav */}
        <nav className="hidden items-center gap-6 md:flex">
          {navLinks.map((link) => (
            <a
              key={link.href}
              href={link.href}
              className="text-sm font-medium text-muted-foreground transition-colors hover:text-foreground"
            >
              {link.label}
            </a>
          ))}
        </nav>

        {/* Desktop CTAs */}
        <div className="hidden items-center gap-2 md:flex">
          <Button size="sm" onClick={scrollToPricing}>
            Get Lifetime Access
          </Button>
        </div>

        {/* Mobile Menu */}
        <Sheet open={isOpen} onOpenChange={setIsOpen}>
          <SheetTrigger asChild>
            <Button variant="ghost" size="icon" className="md:hidden">
              <Menu className="h-5 w-5" />
              <span className="sr-only">Toggle menu</span>
            </Button>
          </SheetTrigger>
          <SheetContent side="right" className="w-[300px] sm:w-[340px] p-0">
            <SheetTitle className="sr-only">Navigation Menu</SheetTitle>
            <SheetDescription className="sr-only">
              Main navigation links and actions for Puppy Pro
            </SheetDescription>

            {/* Brand Header */}
            <div className="flex items-center gap-3 px-6 pt-6 pb-4 border-b border-border/40">
              <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-primary">
                <Dog className="h-5 w-5 text-primary-foreground" />
              </div>
              <div>
                <p className="font-semibold text-foreground">Puppy Pro</p>
                <p className="text-xs text-muted-foreground">Track Progress & Commands</p>
              </div>
            </div>

            {/* Navigation Links */}
            <nav className="flex flex-col py-4" role="navigation" aria-label="Mobile navigation">
              {navLinks.map((link, index) => {
                const Icon = link.icon;
                return (
                  <a
                    key={link.href}
                    ref={index === 0 ? firstNavLinkRef : undefined}
                    href={link.href}
                    className="group flex items-center gap-4 px-6 py-3 min-h-[56px] transition-colors hover:bg-muted/50 focus:bg-muted/50 focus:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-inset"
                    onClick={() => setIsOpen(false)}
                  >
                    <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-muted/80 group-hover:bg-primary/10 transition-colors">
                      <Icon className="h-5 w-5 text-muted-foreground group-hover:text-primary transition-colors" />
                    </div>
                    <div className="flex flex-col">
                      <span className="text-[15px] font-medium text-foreground leading-tight">
                        {link.label}
                      </span>
                      <span className="text-[13px] text-muted-foreground leading-tight mt-0.5">
                        {link.description}
                      </span>
                    </div>
                  </a>
                );
              })}
            </nav>

            {/* CTA Section */}
            <div className="mt-auto px-6 pb-6 pt-4 border-t border-border/40">
              <Button
                className="w-full h-12 text-[15px] font-semibold"
                onClick={scrollToPricing}
              >
                Pay Once, Own Forever
              </Button>

              {/* Trust Badge */}
              <div className="flex items-center justify-center gap-2 mt-4 text-xs text-muted-foreground">
                <Shield className="h-3.5 w-3.5" />
                <span>30-day money-back guarantee</span>
              </div>
            </div>
          </SheetContent>
        </Sheet>
      </div>
    </header>
  );
}
