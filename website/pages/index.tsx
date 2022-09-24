import type { NextPage } from "next";
import { useEffect } from "react";
import Head from "next/head";
// import Image from "next/image";
import Latex from "react-latex-next";
import anime from "animejs";
import prism from "prismjs";
import "prismjs/components/prism-bash";
import "prismjs/plugins/command-line/prism-command-line.js";
import "prismjs/plugins/command-line/prism-command-line.css";

const Home: NextPage = () => {
    const codeSample = `curl https://ceiphr.io/reserver/install | sh
./reserver.sh
Reserving 5GB of space...
Reservation complete!
./reserver.sh
Reservation file already exists. Delete? [y/N]: y
Reservation removed. Good luck!`;

    useEffect(() => {
        prism.highlightAll();
        anime({
            targets: ".slide-in",
            translateY: [20, 0],
            opacity: [0, 1],
            delay: anime.stagger(150, { start: 200 }),
            duration: 1000,
            easing: "easeOutQuart",
        });
    }, []);

    return (
        <div>
            <Head>
                <title>Reserver</title>
                <meta
                    name="description"
                    content="A very mild contingency plan for servers that run out of space. "
                />
                <link rel="icon" href="/favicon.ico" />
            </Head>

            <main className="p-5 md:my-12 max-w-3xl mx-auto">
                <h1 className="slide-in text-6xl">
                    <Latex>{"$\\R \\text{eserver}$"}</Latex>
                </h1>
                <p className="slide-in text-xl text-stone-500 dark:text-stone-400 italic -mt-4 mb-4">
                    /rə&apos;zərvər/
                </p>
                {/* <div className="flex w-fit gap-2 my-2">
                    <a href="https://github.com/ceiphr/reserver/actions/workflows/main.yml">
                        <Image
                            src="https://img.shields.io/github/workflow/status/ceiphr/reserver/CI?color=green&logo=github"
                            alt="CI"
                            layout="fixed"
                            width="105px"
                            height="20px"
                        />
                    </a>
                    <Image
                        src="https://img.shields.io/github/v/release/ceiphr/reserver?color=green"
                        alt="Release"
                        layout="fixed"
                        width="94px"
                        height="20px"
                    />
                    <Image
                        src="https://img.shields.io/badge/bash-v4.4%5E-green?&logo=gnubash&logoColor=white"
                        alt="Bash"
                        layout="fixed"
                        width="97px"
                        height="20px"
                    />
                </div> */}
                <div className="text-xl space-y-5">
                    <p className="slide-in">
                        A <span className="italic">very mild</span> contingency
                        plan for servers that run out of space. Based on this
                        great article by Brian Schrader:{" "}
                        <a
                            href="https://brianschrader.com/archive/why-all-my-servers-have-an-8gb-empty-file/"
                            rel="noreferrer"
                            target="_blank"
                        >
                            Why All My Servers Have An 8gb Empty File
                        </a>
                        .
                    </p>
                    <p className="slide-in">
                        Just like Schrader does in the article, this script will
                        reserve space on a server, so, you can delete it later.
                    </p>
                    <p className="slide-in">
                        Specifically, when your server runs out of space, you
                        can remove the reservation file this script produces so
                        that the server will hopefully have enough space to
                        function again while you try to fix whatever caused the
                        issue.
                    </p>
                    <p className="slide-in">
                        You should always use monitoring software and or SaaS
                        offerings such as{" "}
                        <a
                            href="https://www.datadoghq.com/"
                            rel="noreferrer"
                            target="_blank"
                        >
                            Datadog
                        </a>{" "}
                        to monitor disk usage on your servers. That is the tool
                        that will <span className="italic">really</span> help
                        you mitigate this potential problem. Think of
                        reserver.sh as a sidekick. It&apos;s simple to use and
                        is there if your primary tools somehow fail. It is a{" "}
                        <span className="italic">mild</span> contingency plan if
                        you can spare the disk space.
                    </p>
                    <h2 className="slide-in text-3xl">
                        Installation & Basic Usage
                    </h2>
                    <pre
                        className="slide-in command-line selection:bg-slate-200 dark:selection:bg-slate-700"
                        data-user="user"
                        data-host="remotehost"
                        data-output="3-4, 6-7"
                    >
                        <code className="language-bash">{codeSample}</code>
                    </pre>
                    <h2 className="slide-in text-3xl">Resources</h2>
                    <ul className="slide-in list-disc ml-5">
                        <li>
                            <a href="https://github.com/ceiphr/reserver#usage">
                                Documentation
                            </a>
                        </li>
                        <li>
                            <a href="https://github.com/ceiphr/reserver">
                                Reserver Source Code
                            </a>
                        </li>
                        <li>
                            <a href="https://github.com/ceiphr/get.reserver.sh">
                                Installation Script Source Code
                            </a>
                        </li>
                        <li>
                            <a href="https://github.com/ceiphr/reserver.sh">
                                Website Source Code
                            </a>
                        </li>
                    </ul>
                    <footer className="slide-in">
                        <p>
                            Copyright © 2022 Ari Birnbaum (
                            <a href="https://ceiphr.com/">Ceiphr</a>).
                        </p>
                        <p>
                            Reserver, its installation script and this website
                            are all{" "}
                            <a href="https://github.com/ceiphr/reserver/blob/main/LICENSE">
                                MIT licensed
                            </a>
                            .
                        </p>
                    </footer>
                </div>
            </main>
        </div>
    );
};

export default Home;
