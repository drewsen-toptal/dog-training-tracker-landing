"use client";

import { ArrowRight, Star } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { WaitlistForm } from "@/components/WaitlistForm";

export function Hero() {
  return (
    <section className="relative overflow-hidden bg-background">
      {/* Gradient background */}
      <div className="absolute inset-0 bg-gradient-to-b from-primary/5 via-transparent to-transparent" />

      <div className="container relative mx-auto px-4 py-16 md:px-6 md:py-20 lg:px-8 lg:py-24">
        <div className="mx-auto max-w-4xl text-center">
          {/* Badge */}
          <div className="mb-6 inline-flex items-center gap-2 rounded-full bg-primary/10 px-4 py-1.5 text-sm font-medium text-primary">
            <span className="relative flex h-2 w-2">
              <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-primary opacity-75" />
              <span className="relative inline-flex h-2 w-2 rounded-full bg-primary" />
            </span>
            500 Founding Member Spots Available
          </div>

          {/* Headline */}
          <h1 className="text-4xl font-bold tracking-tight text-foreground md:text-5xl lg:text-6xl">
            Train Your Dog Like a Pro.{" "}
            <span className="text-primary">Pay Once, Keep Forever.</span>
          </h1>

          {/* Subtitle */}
          <p className="mx-auto mt-6 max-w-2xl text-lg text-muted-foreground md:text-xl">
            The dog training app that respects your wallet and your time. No subscriptions.
            No account required. No limits on how many dogs you can train.
          </p>

          {/* Button Group */}
          <div className="mt-10 flex flex-col items-center justify-center gap-4 sm:flex-row">
            <Button size="lg" className="w-full sm:w-auto">
              Get Lifetime Access - $39
              <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
            <Button variant="outline" size="lg" className="w-full sm:w-auto">
              <a href="#features">See How It Works</a>
            </Button>
          </div>

          {/* Pricing Note */}
          <p className="mt-4 text-sm text-muted-foreground">
            One-time payment. Train unlimited dogs.
          </p>

          {/* Waitlist Alternative */}
          <div className="mx-auto mt-8 max-w-md border-t border-border pt-8">
            <p className="mb-3 text-sm text-muted-foreground">
              Not ready to buy? Get notified when we launch new features:
            </p>
            <WaitlistForm variant="hero" />
          </div>

          {/* Social Proof */}
          <div className="mt-10 flex flex-col items-center gap-4 sm:flex-row sm:justify-center">
            <div className="flex gap-1">
              {[...Array(5)].map((_, i) => (
                <Star key={i} className="h-5 w-5 fill-secondary text-secondary" />
              ))}
            </div>
            <div className="text-sm text-muted-foreground">
              <span className="font-semibold text-foreground">4.9 star rating</span>
              {" "}from happy dog owners
            </div>
          </div>

          {/* Trust Badges */}
          <div className="mt-8 flex flex-wrap items-center justify-center gap-3">
            <Badge variant="secondary" className="text-xs">
              30-Day Money-Back Guarantee
            </Badge>
            <Badge variant="secondary" className="text-xs">
              No Account Required
            </Badge>
            <Badge variant="secondary" className="text-xs">
              Works Offline
            </Badge>
          </div>
        </div>
      </div>
    </section>
  );
}
