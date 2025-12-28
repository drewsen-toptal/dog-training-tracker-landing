import { Check, DollarSign, Mail, Users, Wifi, Mouse } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";

const solutions = [
  {
    pain: "Surprise Subscription Charges",
    solution: "One Price. Forever.",
    description: "Pay once, own it for life. No recurring billing. No \"introductory rates\" that triple after month one. The price you see is the price you pay, and you never pay it again.",
    icon: DollarSign,
  },
  {
    pain: "Aggressive Paywalls",
    solution: "No Account Required",
    description: "Open the app. Add your dog. Start training. That's it. No email verification. No password to forget. No marketing emails clogging your inbox. Just you, your dog, and a clicker.",
    icon: Mail,
  },
  {
    pain: '"One Dog" Limits',
    solution: "Unlimited Dogs",
    description: "Got a pack? Add them all. Training your neighbor's dog while they're on vacation? Add that one too. We don't charge per dog because that's ridiculous.",
    icon: Users,
  },
  {
    pain: "No Internet = No Access",
    solution: "Full Offline Mode",
    description: "Train at the park. Track progress at the beach. Log sessions in your backyard with terrible WiFi. Everything works offline, and syncs when you're back online.",
    icon: Wifi,
  },
  {
    pain: "Fumbling for a Separate Clicker",
    solution: "Built-In Clicker",
    description: "One less thing to carry. One less thing to forget at home. Tap the screen, mark the behavior, reward your dog. Simple.",
    icon: Mouse,
  },
];

export function Solution() {
  return (
    <section className="py-16 md:py-20 lg:py-24">
      <div className="container mx-auto px-4 md:px-6 lg:px-8">
        <div className="mx-auto max-w-4xl">
          {/* Section Header */}
          <div className="mb-12 text-center md:mb-16">
            <h2 className="text-2xl font-bold tracking-tight md:text-3xl lg:text-4xl">
              We Built the App We Wished Existed
            </h2>
            <p className="mx-auto mt-4 max-w-2xl text-muted-foreground">
              We&apos;re dog owners too. We got burned by the same subscription traps.
              So we built something different.
            </p>
          </div>

          {/* Solutions Grid */}
          <div className="space-y-6">
            {solutions.map((item, index) => (
              <Card key={index} className="overflow-hidden border-border/50 transition-all duration-300 hover:border-primary/50 hover:shadow-lg">
                <CardContent className="p-0">
                  <div className="flex flex-col md:flex-row">
                    {/* Pain Point */}
                    <div className="flex items-center gap-4 border-b bg-muted/50 p-6 md:w-1/3 md:border-b-0 md:border-r">
                      <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-destructive/10">
                        <item.icon className="h-5 w-5 text-destructive" />
                      </div>
                      <div>
                        <p className="text-xs font-medium uppercase tracking-wider text-muted-foreground">
                          Pain Point
                        </p>
                        <p className="font-semibold text-foreground">{item.pain}</p>
                      </div>
                    </div>

                    {/* Solution */}
                    <div className="flex-1 p-6">
                      <div className="flex items-center gap-2 mb-2">
                        <Check className="h-5 w-5 text-primary" />
                        <p className="font-semibold text-primary">{item.solution}</p>
                      </div>
                      <p className="text-sm text-muted-foreground leading-relaxed">
                        {item.description}
                      </p>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>

          {/* Bottom Line */}
          <div className="mt-12 text-center">
            <p className="text-lg text-muted-foreground">
              <span className="font-semibold text-foreground">Other apps treat you like a subscription to extract.</span>
            </p>
            <p className="mt-2 text-lg text-primary font-semibold">
              We treat you like a dog owner to support.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
}
