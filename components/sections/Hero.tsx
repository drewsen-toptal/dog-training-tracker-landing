"use client";

import { ArrowRight, Star } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { WaitlistForm } from "@/components/WaitlistForm";
import Image from "next/image";

export function Hero() {
  return (
    <section className="relative overflow-hidden bg-background">
      {/* Gradient background */}
      <div className="absolute inset-0 bg-gradient-to-b from-primary/5 via-transparent to-transparent" />

      <div className="container relative mx-auto px-4 py-16 md:px-6 md:py-20 lg:px-8 lg:py-24">
        <div className="grid lg:grid-cols-2 gap-12 items-center">
          {/* Left Column - Content */}
          <div className="mx-auto max-w-xl lg:max-w-none text-center lg:text-left">
            {/* Badge */}
            <div className="mb-6 inline-flex items-center gap-2 rounded-full bg-secondary/20 px-4 py-1.5 text-sm font-medium text-secondary-foreground">
              <span className="relative flex h-2 w-2">
                <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-secondary opacity-75" />
                <span className="relative inline-flex h-2 w-2 rounded-full bg-secondary" />
              </span>
              Founding Member Pricing • Save 60%
            </div>

            {/* Headline */}
            <h1 className="text-4xl font-bold tracking-tight text-foreground md:text-5xl lg:text-6xl">
              Stop Paying $47/Month{" "}
              <span className="text-primary">to Train Your Dog</span>
            </h1>

            {/* Add subheadline */}
            <p className="mt-4 text-xl font-semibold text-foreground">
              Pay $39 once. Own it forever. Save $2,781 over 5 years.
            </p>

            {/* Subtitle */}
            <p className="mx-auto lg:mx-0 mt-6 max-w-2xl text-lg text-muted-foreground md:text-xl">
              The dog training app that respects your wallet and your time. No subscriptions.
              No account required. No limits on how many dogs you can train.
            </p>

            {/* Button Group */}
            <div className="mt-10 flex flex-col items-center lg:items-start justify-center lg:justify-start gap-4 sm:flex-row">
              <Button
                size="lg"
                className="w-full sm:w-auto"
                onClick={() => {
                  const pricingSection = document.getElementById("pricing");
                  if (pricingSection) {
                    pricingSection.scrollIntoView({ behavior: "smooth", block: "start" });
                  }
                }}
                aria-label="Get lifetime access for $39 - view pricing"
              >
                Get Lifetime Access - $39
                <ArrowRight className="ml-2 h-4 w-4" aria-hidden="true" />
              </Button>
              <Button variant="outline" size="lg" className="w-full sm:w-auto" asChild>
                <a href="#features">See How It Works</a>
              </Button>
            </div>

            {/* Pricing Note */}
            <p className="mt-4 text-sm text-muted-foreground">
              One-time payment. Train unlimited dogs.
            </p>
            <p className="mt-2 text-xs text-muted-foreground">
              vs $564/year with subscription apps
            </p>

            {/* Waitlist Alternative */}
            <div className="mx-auto lg:mx-0 mt-8 max-w-md border-t border-border pt-8">
              <p className="mb-3 text-sm text-muted-foreground">
                Not ready to buy? Get notified when we launch new features:
              </p>
              <WaitlistForm variant="hero" />
            </div>

            {/* Social Proof */}
            <div className="mt-10 flex flex-col items-center lg:items-start gap-4 sm:flex-row lg:justify-start">
              <div className="flex gap-1" aria-hidden="true">
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
            <div className="mt-8 flex flex-wrap items-center justify-center lg:justify-start gap-3">
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

          {/* Right Column - App Mockup */}
          <div className="relative hidden lg:flex justify-center items-center">
            {/* Floating decoration elements */}
            <div className="absolute -top-8 -right-8 w-32 h-32 bg-primary/10 rounded-full blur-3xl" />
            <div className="absolute -bottom-8 -left-8 w-40 h-40 bg-secondary/10 rounded-full blur-3xl" />

            {/* Phone Mockup with Real Screenshot */}
            <div className="relative w-full max-w-[300px] aspect-[9/19.5] mx-auto">
              {/* Shadow layers for depth */}
              <div className="absolute inset-0 bg-gradient-to-b from-primary/20 to-primary/5 rounded-[3rem] blur-2xl scale-95" />

              <div className="relative rounded-[2.75rem] bg-gray-900 shadow-2xl overflow-hidden border-[10px] border-gray-900 ring-1 ring-gray-800/50">
                {/* Phone Notch */}
                <div className="absolute top-0 left-1/2 -translate-x-1/2 w-32 h-7 bg-gray-900 rounded-b-3xl z-20" />

                {/* Screenshot Image with improved loading */}
                <div className="relative w-full aspect-[9/19.5] overflow-hidden rounded-[2.25rem] bg-gray-100">
                  <Image
                    src="/screenshots/progress-dashboard.png"
                    alt="Dog Training Progress Dashboard showing success rate and training streak"
                    fill
                    className="object-cover object-top"
                    sizes="(max-width: 1024px) 0px, 300px"
                    priority
                    quality={95}
                    unoptimized={false}
                  />
                </div>

                {/* Home Indicator */}
                <div className="absolute bottom-2 left-1/2 -translate-x-1/2 w-32 h-1.5 bg-white/30 rounded-full z-20" />
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
