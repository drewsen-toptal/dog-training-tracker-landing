import { ArrowRight, Star, Shield, Wifi, UserX, RefreshCw } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";

const successStories = [
  "Luna learned recall in 3 weeks with this app.",
  "Duke stopped pulling on walks in 6 weeks.",
  "Biscuit went from fearful to confident in 4 months.",
];

const trustElements = [
  { icon: Star, label: "4.9 star rating" },
  { icon: Shield, label: "30-day money-back guarantee" },
  { icon: UserX, label: "No account required" },
  { icon: Wifi, label: "Works offline" },
  { icon: RefreshCw, label: "Lifetime updates included" },
];

export function CTA() {
  return (
    <section className="py-16 md:py-20 lg:py-24 bg-gradient-to-b from-background to-muted/50">
      <div className="container mx-auto px-4 md:px-6 lg:px-8">
        <div className="mx-auto max-w-4xl text-center">
          {/* Headline */}
          <h2 className="text-2xl font-bold tracking-tight md:text-3xl lg:text-4xl">
            Ready to Train Smarter?
          </h2>

          {/* Main Copy */}
          <p className="mx-auto mt-6 max-w-2xl text-lg text-muted-foreground">
            You&apos;ve read this far. You know the frustration of subscription traps, per-dog limits,
            and apps that don&apos;t work when you need them most. You&apos;ve seen what&apos;s different
            about Dog Training Tracker.
          </p>

          <p className="mt-4 text-xl font-semibold text-foreground">
            Now there&apos;s just one question: Are you ready to actually train your dog?
          </p>

          {/* Urgency Card */}
          <Card className="mx-auto mt-10 max-w-lg border-secondary/50 bg-secondary/10">
            <CardContent className="p-6">
              <h3 className="font-semibold text-foreground">
                Founding Member Pricing Ends Soon
              </h3>
              <p className="mt-2 text-sm text-muted-foreground">
                We&apos;re offering these launch prices to our first 500 founding members.
                Once we hit 500, prices increase.
              </p>
              <div className="mt-4 grid grid-cols-3 gap-4 text-center">
                <div>
                  <p className="text-xs text-muted-foreground">Puppy</p>
                  <p className="font-semibold">$19 <span className="text-xs text-muted-foreground">→ $49</span></p>
                </div>
                <div>
                  <p className="text-xs text-muted-foreground">Pack Leader</p>
                  <p className="font-semibold text-primary">$39 <span className="text-xs text-muted-foreground">→ $99</span></p>
                </div>
                <div>
                  <p className="text-xs text-muted-foreground">Family</p>
                  <p className="font-semibold">$59 <span className="text-xs text-muted-foreground">→ $149</span></p>
                </div>
              </div>
              <p className="mt-4 text-lg font-bold text-secondary">
                427 of 500 spots remaining
              </p>
              <p className="text-xs text-muted-foreground italic">
                When they&apos;re gone, they&apos;re gone.
              </p>
            </CardContent>
          </Card>

          {/* Primary CTA */}
          <div className="mt-10">
            <p className="mb-4 text-sm font-medium uppercase tracking-wider text-muted-foreground">
              Most Popular Choice
            </p>
            <Button size="lg" className="text-lg px-10 py-6 h-auto">
              Get Pack Leader - $39
              <ArrowRight className="ml-2 h-5 w-5" />
            </Button>
            <p className="mt-3 text-sm text-muted-foreground">
              Unlimited dogs. One-time payment. Lifetime updates.
            </p>
          </div>

          {/* Secondary Options */}
          <div className="mt-6 flex flex-col items-center gap-2 sm:flex-row sm:justify-center sm:gap-6">
            <Button variant="link" className="text-muted-foreground hover:text-foreground">
              Just one dog? Get Puppy for $19
            </Button>
            <Button variant="link" className="text-muted-foreground hover:text-foreground">
              Training as a family? Get Family for $59
            </Button>
          </div>

          {/* Risk Reversal */}
          <div className="mx-auto mt-10 max-w-xl rounded-xl border border-primary/20 bg-primary/5 p-6">
            <div className="flex items-center justify-center gap-2 text-primary">
              <Shield className="h-5 w-5" />
              <h3 className="font-semibold">30-Day &ldquo;Happy Pup&rdquo; Guarantee</h3>
            </div>
            <p className="mt-3 text-sm text-muted-foreground">
              Try Dog Training Tracker for 30 days. Use every feature. Train every day.
              If you don&apos;t love it, if you don&apos;t see progress, if it&apos;s just not for you,
              email us and we&apos;ll refund every penny.
            </p>
            <p className="mt-2 text-sm font-medium text-foreground">
              No questions. No hassle. No hard feelings. Your only risk is not trying.
            </p>
          </div>

          {/* Final Nudge */}
          <div className="mt-10">
            <p className="text-muted-foreground">
              Every day you wait is another day of frustration. Another day of inconsistent training.
            </p>
            <div className="mt-4 space-y-1 text-sm text-muted-foreground">
              {successStories.map((story, index) => (
                <p key={index}>{story}</p>
              ))}
            </div>
            <p className="mt-4 text-lg font-semibold text-foreground">
              What could your dog learn in the next 30 days?
            </p>
          </div>

          {/* Final CTA */}
          <Button size="lg" className="mt-8 text-lg px-10 py-6 h-auto">
            Start Training Today - $39
            <ArrowRight className="ml-2 h-5 w-5" />
          </Button>
          <p className="mt-3 text-sm text-muted-foreground">
            One-time payment. No subscription. No regrets.
          </p>

          {/* Trust Elements */}
          <div className="mt-10 flex flex-wrap items-center justify-center gap-4">
            {trustElements.map((element, index) => (
              <div key={index} className="flex items-center gap-2 text-sm text-muted-foreground">
                <element.icon className="h-4 w-4 text-primary" />
                <span>{element.label}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
